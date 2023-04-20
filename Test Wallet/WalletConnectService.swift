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
            }
            .store(in: &publishers)
        
        Web3Wallet.instance.authRequestPublisher
            .receive(on: DispatchQueue.main)
            .sink { request in
                myPrint("[web3wallet] auth request below:", request)
            }
            .store(in: &publishers)
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
}
