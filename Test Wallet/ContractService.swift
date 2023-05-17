//
//  ContractService.swift
//  Test Wallet
//
//  Created by RBLabs RD - Shane on 2023/5/12.
//

import Foundation
import Web3ContractABI
import Web3
import Combine

@globalActor
actor ContractService {
    
    public static var shared = ContractService()
    private init() {}
    
    private var cancellables = [AnyCancellable]()
    
    private var web3: Web3?
    private var contracts: [String: EthereumContract] = [:]
    
    public func switchNetwork(rpcUrl: String) async throws {
        let temp = Web3(rpcURL: rpcUrl)
        do {
            let version = try await temp.clientVersion().async()
            myPrint("switch network to rpc server: \(version)")
        } catch {
            myPrint("error on switch network", error)
            throw error
        }
        self.web3 = temp
    }
    
    /// this function will reload holdings from opensea and return their contracts
    public func reloadHoldings(for address: EthereumAddress) async throws -> [Opensea.Collection] {
        return try await withCheckedThrowingContinuation { continuation in
            API.shared.request(OpenseaAPIs.retrieveCollections(address: address.hex(eip55: true)))
                .sink { result in
                    switch result {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        print("--- reload holdings finished with continuation")
                    }
                } receiveValue: { collections in
                    continuation.resume(returning: collections)
                }
                .store(in: &self.cancellables)
        }
    }
    
    private func getContractAbi(contract address: String) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            API.shared.request(EtherscanAPIs.AbiFromContract(address: address))
                .sink { result in
                    switch result {
                    case .finished:
                        print("--- abi of \(address) from etherscan finished")
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                } receiveValue: { response in
                    guard let abiString = response.result.safeAbiStringFiltered, let abiData = abiString.data(using: .utf8) else {
                        continuation.resume(throwing: TestWalletError.general("ABI string to data failed"))
                        return
                    }
                    continuation.resume(returning: abiData)
                }
                .store(in: &self.cancellables)
        }
    }
    
    public func addContracts(_ collections: [Opensea.Collection]) async throws {
        for collection in collections {
            for contract in collection.validAssetContracts {
                switch contract.schemaName {
                default:
                    guard let contractAddress = EthereumAddress(hexString: contract.address) else { continue }
                    let abiData = try await getContractAbi(contract: contract.address)
                    await addDynamicContract(name: "\(contract.name) - \(contract.address)", address: contractAddress, abiData: abiData)
                }
            }
        }
        myPrint("\(contracts.count) contracts added", contracts.keys.sorted())
    }
    
    public func removeAllContracts() {
        contracts = [:]
    }
    
    public func getBalance(of address: EthereumAddress) async throws -> EthereumQuantity {
        guard let web3 else {
            throw TestWalletError.general("web3 not initialized")
        }
        return try await web3.eth.getBalance(address: address, block: .latest).async()
    }
    
    private func isAddressContract(_ address: EthereumAddress) async -> Bool {
        guard let web3 else {
            myPrint("web3 is not initialized")
            return false
        }
        if let code = try? await web3.eth.getCode(address: address, block: .latest).async() {
            return code.hex() != "0x"
        }
        return false
    }
    
    public func add20Contract(name: String, address: EthereumAddress) async {
        guard let web3 else { return }
        guard !contracts.keys.contains(name) else { return }
        if await isAddressContract(address) {
            contracts[name] = web3.eth.Contract(type: GenericERC20Contract.self, address: address)
        }
    }
    
    public func add721Contract(name: String, address: EthereumAddress) async {
        guard let web3 else { return }
        guard !contracts.keys.contains(name) else { return }
        if await isAddressContract(address) {
            contracts[name] = web3.eth.Contract(type: GenericERC721Contract.self, address: address)
        }
    }
    
    public func addDynamicContract(name: String, address: EthereumAddress, abiData: Data, abiKey: String? = nil) async {
        guard let web3 else { return }
        guard !contracts.keys.contains(name) else { return }
        if await isAddressContract(address) {
            do {
                let contract = try web3.eth.Contract(json: abiData, abiKey: abiKey, address: address)
                contracts[name] = contract
            } catch {
                print("--- error on adding dynamic contract", error)
            }
        }
    }
    
    public func getContracts() -> [String] {
        return contracts.keys.sorted()
    }
}

// MARK: ERC-721 Contract Parsing
extension ContractService {
    public func getErc721Contract(_ name: String) -> GenericERC721Contract? {
        guard contracts.keys.contains(name), let contract = contracts[name] else { return nil }
        return contract as? GenericERC721Contract
    }
}

// MARK: Dynamic Contract Parsing
extension ContractService {
    
    public func getDynamicContract(_ name: String) -> DynamicContract? {
        guard contracts.keys.contains(name), let contract = contracts[name] else { return nil }
        return contract as? DynamicContract
    }
    
    public func getDynamicMethods(name: String) -> [String] {
        guard let contract = contracts[name] as? DynamicContract else {
            return []
        }
        return contract.methods.keys.sorted()
    }
    
    public func getDynamicMethodInputs(name: String, method: String) -> [String: SolidityType] {
        guard
            let contract = contracts[name] as? DynamicContract,
            let method = contract.methods[method]
        else {
            return [:]
        }
        return method.inputs.reduce(into: [:]) { $0[$1.name] = $1.type }
    }
    
    public func makeDynamicMethodRequest(name: String, method: String, inputs: [ABIEncodable]) -> SolidityInvocation? {
        guard
            let contract = contracts[name] as? DynamicContract,
            let method = contract.methods[method] as? BetterInvocation
        else {
            return nil
        }
        return method.betterInvoke(inputs)
    }
}

public protocol BetterInvocation {
    /// Invokes this function with the provided values
    ///
    /// - Parameter inputs: Input values. Must be in the correct order.
    /// - Returns: Invocation object
    func betterInvoke(_ inputs: [ABIEncodable]) -> SolidityInvocation
}

extension SolidityConstantFunction: BetterInvocation {
    public func betterInvoke(_ inputs: [ABIEncodable]) -> SolidityInvocation {
        return SolidityReadInvocation(method: self, parameters: inputs, handler: handler)
    }
}

extension SolidityNonPayableFunction: BetterInvocation {
    public func betterInvoke(_ inputs: [ABIEncodable]) -> SolidityInvocation {
        return SolidityNonPayableInvocation(method: self, parameters: inputs, handler: handler)
    }
}

extension SolidityPayableFunction: BetterInvocation {
    public func betterInvoke(_ inputs: [ABIEncodable]) -> SolidityInvocation {
        return SolidityPayableInvocation(method: self, parameters: inputs, handler: handler)
    }
}
