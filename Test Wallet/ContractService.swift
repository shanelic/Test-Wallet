//
//  ContractService.swift
//  Test Wallet
//
//  Created by RBLabs RD - Shane on 2023/5/12.
//

import Foundation
import Web3ContractABI
import Web3
import Moya
import CombineMoya
import Combine

class ContractService {
    
    public static var shared = ContractService()
    private init() {}
    
    private var cancellables = [AnyCancellable]()
    
    public func setup(rpcUrl: String) {
        self.web3 = Web3(rpcURL: rpcUrl)
        
        if let walletAddress {
            API.shared.request(OpenseaAPIs.retrieveCollections(address: walletAddress.hex(eip55: true)))
                .sink { result in
                    switch result {
                    case .finished:
                        print("--- collections from opensea finished")
                    case .failure(let error):
                        print("--- error on opensea", error)
                    }
                } receiveValue: { collections in
                    print("--- collections from opensea", collections)
                    for collection in collections {
                        for contract in collection.primaryAssetContracts {
                            switch contract.schemaName {
                            case .ERC721:
                                guard let contractAddress = EthereumAddress(hexString: contract.address) else { continue }
                                self.add721Contract(name: "\(contract.name)-\(contract.address)", address: contractAddress)
                                print("--- contracts saved", self.getContracts())
                            default:
                                break
                            }
                        }
                    }
                }
                .store(in: &cancellables)
        } else {
            print("--- private key init failed.")
        }

    }
    
    private var web3: Web3?
    private var contracts: [String: EthereumContract] = [:]
    
    private var walletAddress: EthereumAddress? {
        try? EthereumPrivateKey(hexPrivateKey: MY_PRIVATE_KEY).address
    }
    
    public func add20Contract(name: String, address: EthereumAddress) {
        guard let web3 else { return }
        guard !contracts.keys.contains(name) else { return }
        contracts[name] = web3.eth.Contract(type: GenericERC20Contract.self, address: address)
    }
    
    public func add721Contract(name: String, address: EthereumAddress) {
        guard let web3 else { return }
        guard !contracts.keys.contains(name) else { return }
        guard let walletAddress else { return }
        contracts[name] = web3.eth.Contract(type: GenericERC721Contract.self, address: address)
    }
    
    public func addDynamicContract(name: String, address: EthereumAddress, abiData: Data, abiKey: String? = nil) {
        guard let web3 else { return }
        guard !contracts.keys.contains(name) else { return }
        do {
            let contract = try web3.eth.Contract(json: abiData, abiKey: abiKey, address: address)
            contracts[name] = contract
        } catch {
            print("--- error on adding dynamic contract", error)
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
