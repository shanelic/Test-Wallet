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

struct ContentView: View {
    
    @State var rpcUrl = "http://127.0.0.1:8545/"
    
    @State var web3: Web3?
    @State var web3state = "Blockchain connected yet."
    
    @State var contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3"
    
    @State var contract: DynamicContract?
    @State var contractMessage = ""
    
    @State var methodName = "getMyAddress"
    @State var canCall = false
    @State var callResponse = ""
    
    func reset() {
        rpcUrl = "http://127.0.0.1:8545/"
        
        web3 = nil
        web3state = "Blockchain connected yet."
        
        contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3"
        
        contract = nil
        contractMessage = ""
    }
    
    func connect2web3() {
        web3 = Web3(rpcURL: rpcUrl)
        web3?.eth.accounts()
            .done { accounts in
                web3state = "Blockchain connected!\nThe main account address is \(accounts.first?.hex(eip55: true) ?? "N/A")"
            }
            .catch { error in
                web3state = error.localizedDescription
                web3 = nil
            }
            .finally {
                methodNameOnChange(newValue: methodName)
            }
    }
    
    func addContract() {
        contractMessage = ""
        guard let address = EthereumAddress(hexString: contractAddress) else {
            contractMessage += "\nContract address initializing failed."
            methodNameOnChange(newValue: methodName)
            return
        }
        guard let abi_url = Bundle.main.url(forResource: "abi", withExtension: "json"),
            let abi_data = try? Data(contentsOf: abi_url) else {
            contractMessage += "\nABI json file loading failed."
            methodNameOnChange(newValue: methodName)
            return
        }
        do {
            contract = try web3?.eth.Contract(json: abi_data, abiKey: nil, address: address)
            guard web3 != nil, contract != nil else {
                methodNameOnChange(newValue: methodName)
                return
            }
            contractMessage = "Contract Added!\nThere are \(contract?.methods.count ?? -1) methods in the contract"
            methodNameOnChange(newValue: methodName)
        } catch {
            contractMessage += "\n\(error.localizedDescription)"
            methodNameOnChange(newValue: methodName)
        }
    }
    
    func methodNameOnChange(newValue: String) {
        if contract?[newValue] != nil {
            canCall = true
        } else {
            canCall = false
        }
    }
    
    func callMethod() {
        guard let contract = contract else {
            callResponse = ""
            return
        }
        guard let method = contract[methodName] else {
            callResponse = ""
            return
        }
        firstly {
            method().call()
        }
        .done { outputs in
            print(outputs)
            callResponse = outputs.description
        }
        .catch { error in
            print(error)
            callResponse = error.localizedDescription
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, Wallet!")
                .font(.title)
            VStack(spacing: 20) {
                // RPC
                VStack(alignment: .leading) {
                    Text("RPC Url")
                        .font(.headline)
                    TextField("RPC Url", text: $rpcUrl)
                }
                // Wallet
                VStack(spacing: 8) {
                    Button("Connect Wallet", action: connect2web3)
                        .disabled(web3 != nil)
                        .frame(maxWidth: .infinity)
                    Text(web3state)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                // Address
                VStack(alignment: .leading) {
                    Text("Contract Address")
                        .font(.headline)
                    TextField("Contract Address", text: $contractAddress)
                        .lineLimit(2)
                }
                // Contract
                VStack(spacing: 8) {
                    Button("Add Contract", action: addContract)
                        .disabled(contract != nil)
                        .frame(maxWidth: .infinity)
                    Text(contractMessage)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                // Method
                VStack(alignment: .leading) {
                    Text("Method")
                        .font(.headline)
                    TextField("Method Name", text: $methodName)
                        .lineLimit(1)
                        .onChange(of: methodName, perform: methodNameOnChange(newValue:))
                }
                // Call
                VStack(spacing: 8) {
                    Button("Call " + methodName, action: callMethod)
                        .disabled(!canCall)
                        .frame(maxWidth: .infinity)
                    Text(callResponse)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
