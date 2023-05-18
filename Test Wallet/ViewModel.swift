//
//  ViewModel.swift
//  Test Wallet
//
//  Created by RBLabs RD - Shane on 2023/3/21.
//

import Foundation
import Web3
import Web3Wallet
import Web3ContractABI

class ViewModel: ObservableObject {
    
    @Published private var wallets: [EthereumPrivateKey] = []
    var addresses: [EthereumAddress] {
        wallets.map { $0.address }
    }
    @Published var selectedWalletIndex: Int = 0
    private var wallet: EthereumPrivateKey? {
        if selectedWalletIndex + 1 <= wallets.count {
            return wallets[selectedWalletIndex]
        } else {
            return nil
        }
    }
    public var walletAddress: EthereumAddress? {
        wallet?.address
    }
    
    @Published var networks: [Network] = [
        .EthereumMainnet,
        .EthereumGoerli,
        .PolygonMainnet,
        .PomoTestnet,
    ]
    @Published var selectedNetworkIndex: Int = 0 {
        didSet {
            myPrint("Network will change to \(selectedNetwork.name)")
            initialNetwork(selectedNetwork)
        }
    }
    
    var selectedNetwork: Network {
        networks[selectedNetworkIndex]
    }
    
    private var collections: [Opensea.Collection] = []
    
    @Published var contracts: [Opensea.AssetContract] = []
    @Published var selectedContractIndex: Int = 0 {
        didSet {
            Task {
                let contract = await reloadContract(selectedContractIndex)
                await MainActor.run {
                    _selectedContract = contract
                }
            }
        }
    }
    @Published private var _selectedContract: EthereumContract? = nil
    
    var constantMethodsInContract: [String: SolidityFunction] {
        if let _ = _selectedContract as? GenericERC721Contract {
            // TODO: give the erc721 standard methods
            return [:]
        } else if let contract = _selectedContract as? DynamicContract {
            let constants = contract.methods.filter { ($0.value as? BetterInvocation)?.type == .constant }
            return constants
        } else {
            return [:]
        }
    }
    
    @Published var selectedMethod: (String, SolidityFunction)? = nil
    
    public func importWallet(privateKey: String) throws {
        let wallet = try EthereumPrivateKey(hexPrivateKey: privateKey)
        if !wallets.contains(where: { $0.address == wallet.address }) {
            wallets.append(wallet)
        } else {
            throw TestWalletError.general("Duplicated Private Key, Please Check Again.")
        }
    }
    
    @Published private var _balance: EthereumQuantity = 0
    public var balance: Double {
        let stringValue = "\(_balance.quantity)"
        if stringValue.count > 13 {
            return ((Double(stringValue.dropLast(11)) ?? 0.0) / 10).rounded() / 1_000_000
        } else {
            return 0.0
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
                let balance = try await reloadBalance(of: walletAddress)
                let collections = try await retrieveCollections(of: walletAddress)
                try await reloadCollectionContracts(collections)
                await MainActor.run {
                    self._balance = balance
                    self.collections = collections
                    self.contracts = collections.reduce([], { $0 + $1.validAssetContracts })
                    self.selectedContractIndex = { selectedContractIndex }()
                }
            } catch {
                errorHandler(error)
            }
        }
    }
    
    private func switchNetwork(_ rpcServer: Network.RpcServer) async throws {
        try await ContractService.shared.switchNetwork(rpcUrl: rpcServer.url)
    }
    
    private func reloadBalance(of address: EthereumAddress) async throws -> EthereumQuantity {
        return try await ContractService.shared.getBalance(of: address)
    }
    
    private func retrieveCollections(of address: EthereumAddress) async throws -> [Opensea.Collection] {
        var collections = try await ContractService.shared.retrieveCollections(for: address)
        for index in 0 ..< collections.count {
            collections[index].appliedChain = selectedNetwork.chainIdentity
        }
        return collections
    }
    
    private func reloadCollectionContracts(_ collections: [Opensea.Collection]) async throws {
        await ContractService.shared.removeAllContracts()
        try await ContractService.shared.addContracts(collections)
    }
    
    private func reloadContract(_ selectedContractIndex: Int) async -> EthereumContract? {
        guard selectedContractIndex + 1 <= contracts.count else {
            return nil
        }
        let openseaContract = contracts[selectedContractIndex]
        let contracts = await ContractService.shared.getContracts()
        if contracts.contains("\(openseaContract.name) - \(openseaContract.address)") {
            switch openseaContract.schemaName {
            default:
                return await ContractService.shared.getDynamicContract("\(openseaContract.name) - \(openseaContract.address)")
            }
        } else {
            return nil
        }
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
    let chainIdentity: Opensea.ChainIdentity
    
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
    
    static var chains: [Blockchain] {
        [
            EthereumMainnet.blockchain,
            EthereumGoerli.blockchain,
            PolygonMainnet.blockchain,
            PomoTestnet.blockchain,
        ]
    }
    
    static func getAccounts(by address: EthereumAddress) -> [Account] {
        chains.compactMap { Account(blockchain: $0, address: address.hex(eip55: true)) }
    }
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
    
    var simpleAddress: String {
        return self.dropLast(34) + "..." + self.dropFirst(36)
    }
}
