//
//  ViewModel.swift
//  Test Wallet
//
//  Created by RBLabs RD - Shane on 2023/3/21.
//

import Foundation
import Web3
import Web3Wallet

class ViewModel: ObservableObject {
    
    @Published var selectedNetworkIndex: Int = 0 {
        didSet {
            myPrint("Network will change to \(selectedNetwork.name)")
            initialNetwork(selectedNetwork)
        }
    }
    
    @Published var networks: [Network] = [
        .EthereumMainnet,
        .EthereumGoerli,
        .PolygonMainnet,
        .PomoTestnet,
    ]
    
    var selectedNetwork: Network {
        networks[selectedNetworkIndex]
    }
    
    @Published var collections: [Opensea.Collection] = [] {
        didSet {
        }
    }
    
    init() {
        initialNetwork(selectedNetwork)
    }
    
    private func initialNetwork(_ network: Network) {
        Task {
            do {
                guard let rpcServer = network.rpcServers.first else { return }
                try await switchNetwork(rpcServer)
                guard let walletAddress else { return }
                let collections = try await reloadHoldings(of: walletAddress)
                await MainActor.run {
                    self.collections = collections
                }
            } catch {
                errorHandler(error)
            }
        }
    }
    
    private func switchNetwork(_ rpcServer: Network.RpcServer) async throws {
        try await ContractService.shared.switchNetwork(rpcUrl: rpcServer.url)
    }
    
    private func reloadHoldings(of address: EthereumAddress) async throws -> [Opensea.Collection] {
        var collections = try await ContractService.shared.reloadHoldings(for: address)
        for index in 0 ..< collections.count {
            collections[index].appliedChain = selectedNetwork.chainIdentity
        }
        return collections
    }
    
    private func errorHandler(_ error: Error) {
        myPrint(error)
    }
    
}

struct Network {
    let name: String
    let chainId: Int
    let rpcServers: [RpcServer]
    let multicall3: String
    
    var eip155: String {
        "eip155:\(chainId)"
    }
    var blockchain: Blockchain {
        Blockchain(eip155)!
    }
    
    struct RpcServer {
        let url: String
        let type: RpcServerProtocol
        
        enum RpcServerProtocol {
            case http
            case websocket
        }
    }
    
    static let EthereumMainnet = Network(name: "Ethereum Mainnet", chainId: 1, rpcServers: [
        RpcServer(url: "https://cloudflare-eth.com", type: .http),
    ], multicall3: "0xca11bde05977b3631167028862be2a173976ca11", chainIdentity: .ethereum)
    static let EthereumGoerli = Network(name: "Ethereum Goerli", chainId: 5, rpcServers: [
        RpcServer(url: "https://rpc.ankr.com/eth_goerli", type: .http),
    ], multicall3: "0xca11bde05977b3631167028862be2a173976ca11", chainIdentity: .goerli)
    static let PolygonMainnet = Network(name: "Polygon Mainnet", chainId: 137, rpcServers: [
        RpcServer(url: "https://polygon-rpc.com", type: .http),
    ], multicall3: "0xca11bde05977b3631167028862be2a173976ca11", chainIdentity: .matic)
    static let PomoTestnet = Network(name: "POMO Testnet", chainId: 1337, rpcServers: [
        RpcServer(url: "https://dev-ganache.pomo.network/:9527", type: .http)
    ], multicall3: "0xca11bde05977b3631167028862be2a173976ca11", chainIdentity: .pomo)
}

func myPrint(_ items: Any...) {
    print(":::", items)
}

let CONTRACT_ADDRESS = "0x09430eF1032bBB52c4F60BC00Bb0AaC1dfEd3972"

let MY_PRIVATE_KEY = "0x7742f00f27407887563707673c4c0afaab1c87fbe6cabf5547aeb58fe2260cdd"

let ETHERSCAN_API_KEY = "QNCD24AX3PTV5B3KMUP5FN95WE1JWZCIBS"
let OPENSEA_API_KEY = "c823fdee93814f7abd5492604697e9c8"

enum ERC: String, Codable {
    case ERC20
    case ERC721
    case ERC1155
    case unknown
    
    init(_ rawValue: String) {
        switch rawValue
            .uppercased()
            .replacingOccurrences(of: "-", with: "")
        {
        case "ERC20":
            self = .ERC20
        case "ERC721":
            self = .ERC721
        case "ERC1155":
            self = .ERC1155
        default:
            self = .unknown
        }
    }
}

extension Int {
    var ethQty: EthereumQuantity {
        return EthereumQuantity(quantity: BigUInt(self))
    }
}

extension String {
    var safeAbiStringFiltered: String? {
        let jsonDecoder = JSONDecoder()
        guard let data = self.data(using: .utf8) else { return nil }
        guard let elements = try? jsonDecoder.decode(Array<Dictionary<String, AnyCodable>>.self, from: data) else { return nil }
        let result = elements.filter { ($0["type"]?.value as? String) != "error" }
        return try? result.json()
    }
}
