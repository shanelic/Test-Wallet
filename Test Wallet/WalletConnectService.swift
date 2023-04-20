//
//  WalletConnectService.swift
//  Test Wallet
//
//  Created by RBLabs RD - Shane on 2023/4/11.
//

import Foundation
import Web3Wallet
import Starscream
import WalletConnectRelay
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
    
    init() {
        let metadata = AppMetadata(name: "Test Wallet", description: "The Test Wallet For POMO Network demo", url: "https://pomo.network", icons: [])
        Networking.configure(projectId: projectId, socketFactory: DefaultSocketFactory())
        web3WalletInitializer(metadata)
    }
    
    private func web3WalletInitializer(_ metadata: AppMetadata) {
        Web3Wallet.configure(metadata: metadata, crypto: DefaultCryptoProvider(), environment: .sandbox)
    }
}
