//
//  WalletConnectService.swift
//  Test Wallet
//
//  Created by RBLabs RD - Shane on 2023/4/11.
//

import Foundation
import Web3Wallet
import Starscream
import Combine
import Web3
import CryptoSwift

extension WebSocket: WebSocketConnecting { }

struct DefaultSocketFactory: WebSocketFactory {
    func create(with url: URL) -> WebSocketConnecting {
        return WebSocket(url: url)
    }
}

struct DefaultCryptoProvider: CryptoProvider {
    func recoverPubKey(signature: WalletConnectSigner.EthereumSignature, message: Data) throws -> Data {
        let publicKey = try EthereumPublicKey(
            message: message.bytes,
            v: EthereumQuantity(quantity: BigUInt(signature.v)),
            r: EthereumQuantity(signature.r),
            s: EthereumQuantity(signature.s)
        )
        return Data(publicKey.rawPublicKey)
    }
    
    func keccak256(_ data: Data) -> Data {
        let digest = SHA3(variant: .keccak256)
        let hash = digest.calculate(for: [UInt8](data))
        return Data(hash)
    }
}

class WalletConnectService {
    
    let projectId = "2bb215526074ffd643daeac97beb0993"
    
    private var publishers = [AnyCancellable]()
    
    init() {
        let metadata = AppMetadata(name: "Test Wallet", description: "The Test Wallet For POMO Network demo", url: "https://pomo.network", icons: [])
        Networking.configure(projectId: projectId, socketFactory: DefaultSocketFactory())
        web3WalletInitializer(metadata)
    }
    
    private func web3WalletInitializer(_ metadata: AppMetadata) {
        Web3Wallet.configure(metadata: metadata, crypto: DefaultCryptoProvider(), environment: .sandbox)
        
        Web3Wallet.instance.sessionProposalPublisher
            .receive(on: DispatchQueue.main)
            .sink { proposal in
                myPrint("[web3wallet] session proposal below:", proposal)
                if let myPrivateKey = try? EthereumPrivateKey(hexPrivateKey: MY_PRIVATE_KEY),
                   let account = Account(chainIdentifier: Chain.Ethereum_Goerli.eip155, address: myPrivateKey.address.hex(eip55: true))
                {
                    Task.detached { [unowned self] in
                        await approveProposal(proposal, by: account)
                    }
                } else {
                    myPrint("[web3wallet] initial account failed.")
                }
            }
            .store(in: &publishers)
        
        Web3Wallet.instance.sessionSettlePublisher
            .receive(on: DispatchQueue.main)
            .sink { settle in
                myPrint("[web3wallet] settle below:", settle)
            }
            .store(in: &publishers)
        
        Web3Wallet.instance.sessionRequestPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] request in
                myPrint("[web3wallet] session request \(request.method) below: ", request)
                parseSessionRequest(request)
            }
            .store(in: &publishers)
        
        Web3Wallet.instance.authRequestPublisher
            .receive(on: DispatchQueue.main)
            .sink { request in
                myPrint("[web3wallet] auth request below:", request)
            }
            .store(in: &publishers)
    }
    
    func approveProposal(_ proposal: Session.Proposal, by account: Account) async {
        do {
            let goerli = Chain.Ethereum_Goerli.blockchain
            guard let requiredEip155 = proposal.requiredNamespaces["eip155"] else {
                myPrint("[web3wallet] approving proposal: required eip-155 initializing failed.")
                return
            }
            guard requiredEip155.chains?.contains(goerli) ?? false, requiredEip155.chains?.count ?? 0 == 1 else {
                myPrint("[web3wallet] the proposal requires blockchain(s) we are not supporting yet.")
                myPrint("[web3wallet] the blockchain we supports only now is \(goerli).")
                return
            }
            let namespace = try AutoNamespaces.build(
                sessionProposal: proposal,
                chains: [
                    goerli
                ],
                methods: requiredEip155.methods.sorted(),
                events: requiredEip155.events.sorted(),
                accounts: [
                    account
                ]
            )
            try await Web3Wallet.instance.approve(proposalId: proposal.id, namespaces: namespace)
        } catch {
            myPrint("[web3wallet] approving proposal failed: ", error.localizedDescription)
        }
    }
    
    private func personalSign(message: String, privateKey: EthereumPrivateKey) throws -> String {
        let (v, r, s) = try privateKey.sign(message: dataToHash(message))
        let hexString = "0x" + r.hex + s.hex + String(v + 27, radix: 16)
        return hexString
        
        func dataToHash(_ message: String) -> Bytes {
            let prefix = "\u{19}Ethereum Signed Message:\n"
            let messageData = Data(hex: message)
            let prefixData = (prefix + String(messageData.count)).data(using: .utf8)!
            let prefixedMessageData = prefixData + messageData
            let dataToHash = Bytes(hex: prefixedMessageData.hex)
            return dataToHash
        }
    }
    
    func parseSessionRequest(_ request: Request) {
        guard let myPrivateKey = try? EthereumPrivateKey(hexPrivateKey: MY_PRIVATE_KEY) else {
            return
        }
        switch request.method {
        case "personal_sign":
            do {
                let params = try request.params.get([String].self)
                myPrint("plain text: " + params[0].hexToBytes().makeString())
                let result = try personalSign(message: params[0], privateKey: myPrivateKey)
                Task.detached { [unowned self] in
                    await respondRequest(request, content: AnyCodable(result))
                }
            } catch {
                myPrint("error occurred on personal signing: ", error.localizedDescription)
                Task.detached { [unowned self] in
                    await rejectRequest(request)
                }
            }
        case "eth_signTypedData":
        case "eth_signTransaction":
        default:
            Task.detached { [unowned self] in
                await rejectRequest(request)
            }
        }
    }
    
    func respondRequest(_ request: Request, content: AnyCodable) async {
        do {
            try await Web3Wallet.instance.respond(topic: request.topic, requestId: request.id, response: .response(content))
        } catch {
            myPrint("[web3wallet] responding request failed: ", error.localizedDescription)
        }
    }
    
    func rejectRequest(_ request: Request) async {
        do {
            try await Web3Wallet.instance.reject(requestId: request.id)
        } catch {
            myPrint("[web3wallet] rejecting request failed: ", error.localizedDescription)
        }
    }
    
    func connectWallet(url: String) async {
        guard url.hasPrefix("wc:"), let uri = WalletConnectURI(string: url) else {
            myPrint("wallet connect uri initializing failed", url.hasPrefix("wc:"), url)
            return
        }
        do {
            try await Web3Wallet.instance.pair(uri: uri)
        } catch {
            myPrint("web3wallet pairing", error.localizedDescription)
        }
    }
    
    func getAllConnectedWallets() -> [Pairing] {
        return Web3Wallet.instance.getPairings()
    }
    
    func disconnectWallet(_ topic: String? = nil) async {
        if let topic {
            await disconnectSession(topic)
        } else {
            for session in Web3Wallet.instance.getSessions() {
                await disconnectSession(session.topic)
            }
            for pairing in Web3Wallet.instance.getPairings() {
                await disconnectPairing(pairing.topic)
            }
        }
    }
    
    private func disconnectPairing(_ pairing: String) async {
        do {
            try await Web3Wallet.instance.disconnectPairing(topic: pairing)
        } catch {
            myPrint("error occurred on disconnecting pairing: ", error.localizedDescription)
        }
    }
    
    private func disconnectSession(_ session: String) async {
        do {
            try await Web3Wallet.instance.disconnect(topic: session)
        } catch {
            myPrint("error occurred on disconnecting session: ", error.localizedDescription)
        }
    }
}
