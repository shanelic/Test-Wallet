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

extension WebSocket: WebSocketConnecting { }

struct DefaultSocketFactory: WebSocketFactory {
    func create(with url: URL) -> WebSocketConnecting {
        return WebSocket(url: url)
    }
}

class WalletConnectService {
    
    let projectId = "2bb215526074ffd643daeac97beb0993"
    
    init() {
        Networking.configure(projectId: projectId, socketFactory: DefaultSocketFactory())
        let metadata = AppMetadata(name: "Test Wallet", description: "The Test Wallet For POMO Network demo", url: "https://pomo.network", icons: [])
        Pair.configure(metadata: metadata)
    }
}
