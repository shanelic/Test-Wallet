//
//  ContentView.swift
//  Test Wallet
//
//  Created by RBLabs RD - Shane on 2023/3/21.
//

import SwiftUI
import Web3
import Web3PromiseKit
import Web3ContractABI

/*
 
 Account #0: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000 ETH)
 Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
 
 Account #1: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 (10000 ETH)
 Private Key: 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
 
 */

enum TestWalletError: Error {
    case general(_ reason: String)
}

struct ContentView: View {
    
    @State var rpcUrl = "http://10.14.67.4"
    @State var rpcPort = "7000"
    
    @State var web3: Web3?
    @State var contractAddress = "0xa4c02eC587071d37eEbb345332942E99E0499eD4"
    @State var erc721Contract: GenericERC721Contract?
    @State var dynamicContract: DynamicContract?
    
    @State var contractMessage = ""
    
    @State var methodResponse = ""
    
    @State var myPrivateKey = "0x7742f00f27407887563707673c4c0afaab1c87fbe6cabf5547aeb58fe2260cdd"
    @State var otherPrivateKey = "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"
    
    func myPrint(_ items: Any...) {
        print(":::", items)
    }
    
    func reset() {
        rpcUrl = "http://10.14.67.4"
        rpcPort = "7000"
        
        web3 = nil
        
        contractAddress = "0xa4c02eC587071d37eEbb345332942E99E0499eD4"
        
        dynamicContract = nil
        contractMessage = ""
    }
    
    func connect2web3() {
        contractMessage = ""
        dynamicContract = nil
        web3 = Web3(rpcURL: "\(rpcUrl):\(rpcPort)")
        guard let web3 = web3 else {
            contractMessage = "web3 network not connected."
            return
        }
        web3.clientVersion()
            .then { version in
                contractMessage = "The client version is \(version)"
                guard let address = EthereumAddress(hexString: contractAddress) else {
                    throw TestWalletError.general("contract address is invalid.")
                }
                return web3.eth.getCode(address: address, block: .latest)
            }
            .done { code in
                if code.hex() == "0x" {
                    throw TestWalletError.general("The Address provided is not a contract.")
                } else {
                    guard let abi_url = Bundle.main.url(forResource: "abi", withExtension: "json"),
                        let abi_data = try? Data(contentsOf: abi_url) else {
                        throw TestWalletError.general("ABI json file loading failed.")
                    }
                    guard let address = EthereumAddress(hexString: contractAddress) else {
                        throw TestWalletError.general("contract address is invalid.")
                    }
                    dynamicContract = try web3.eth.Contract(json: abi_data, abiKey: nil, address: address)
                    erc721Contract = web3.eth.Contract(type: GenericERC721Contract.self, address: address)
                }
            }
            .catch { error in
                contractMessage = errorHandler(error)
            }
    }
    
    func getEthBalance() {
        guard
            let web3 = web3,
            let myPrivateKey = try? EthereumPrivateKey(hexPrivateKey: myPrivateKey)
        else {
            methodResponse = "Initializing failed."
            return
        }
        web3.eth.getBalance(address: myPrivateKey.address, block: .latest)
            .done { balance in
                methodResponse = "\(balance.quantity)"
            }
            .catch { error in
                methodResponse = errorHandler(error)
            }
    }
    
    func getNftBalance() {
        guard
            let erc721Contract = erc721Contract,
            let myPrivateKey = try? EthereumPrivateKey(hexPrivateKey: myPrivateKey)
        else {
            methodResponse = "Initializing failed."
            return
        }
        erc721Contract
            .balanceOf(address: myPrivateKey.address)
            .call()
            .done { balance in
                methodResponse = "\(balance["_balance"] ?? "N/A")"
            }
            .catch { error in
                methodResponse = errorHandler(error)
            }
    }
    
    private func errorHandler(_ error: Error) -> String {
        myPrint(error)
        if case .general(let reason) = error as? TestWalletError {
            return reason
        } else if let error = error as? RPCResponse<EthereumQuantity>.Error {
            return error.message
        } else if let error = error as? RPCResponse<EthereumData>.Error {
            return error.message
        } else if case .invalidInvocation = error as? InvocationError {
            return (error as! InvocationError).localizedDescription
        } else {
            return error.localizedDescription
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, Wallet!")
                .font(.title)
            VStack(spacing: 20) {
                // RPC URL
                VStack(alignment: .leading) {
                    Text("RPC Url")
                        .font(.headline)
                    TextField("RPC Url", text: $rpcUrl)
                        .keyboardType(.URL)
                }
                // RPC PORT
                VStack(alignment: .leading) {
                    Text("RPC Port")
                        .font(.headline)
                    TextField("RPC Port", text: $rpcPort)
                }
                // Address
                VStack(alignment: .leading) {
                    Text("Contract Address")
                        .font(.headline)
                    TextField("Contract Address", text: $contractAddress)
                        .lineLimit(2)
                }
                VStack(alignment: .leading) {
                    Text("My Private Key")
                        .font(.headline)
                    TextField("Private Key", text: $myPrivateKey)
                        .lineLimit(2)
                }
                // Contract
                VStack(spacing: 8) {
                    Button("Connect Blockchain", action: connect2web3)
                        .frame(maxWidth: .infinity)
                    Text(contractMessage)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                // Call
                VStack(spacing: 8) {
                    Button("Get ETH Balance", action: getEthBalance)
                        .frame(maxWidth: .infinity)
                    Button("Get NFT Balance", action: getNftBalance)
                        .frame(maxWidth: .infinity)
                    Text(methodResponse)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                // Reset
                VStack {
                    Button("RESET", action: reset)
                }
            }
            .padding()
            .background {
                Color(.clear)
            }
            .cornerRadius(8)
            Spacer()
        }
        .padding()
        .onAppear(perform: connect2web3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
