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
    
    @State var rpcUrl = "http://shanelicrblabsio.local"
    @State var rpcPort = "8545"
    
    @State var web3: Web3?
    @State var web3state = "Blockchain connected yet."
    
    @State var contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3"
    
    @State var contract: DynamicContract?
    @State var contractMessage = ""
    
    @State var methodName = "mint"
    
    @State var canCall = false
    
    @State var callResponse = ""
    @State var estimateResponse = ""
    @State var sendResponse = ""
    
    @State var method: SolidityFunction?
    @State var inputs: [(String, String)] = []
    
    func reset() {
        rpcUrl = "http://shanelicrblabsio.local"
        rpcPort = "8545"
        
        web3 = nil
        web3state = "Blockchain connected yet."
        
        contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3"
        
        contract = nil
        contractMessage = ""
        
        methodName = "getMyBalance"
        
        canCall = false
        
        callResponse = ""
        estimateResponse = ""
        sendResponse = ""
    }
    
    func connect2web3() {
        web3 = Web3(rpcURL: "\(rpcUrl):\(rpcPort)")
        web3?.clientVersion()
            .done { result in
                web3state = "Blockchain connected!\nThe client version is \(result)"
            }
            .catch { error in
                web3state = error.localizedDescription
            }
            .finally {
                methodNameOnChange(newValue: methodName)
            }
    }
    
    func addContract() {
        contractMessage = ""
        guard let address = EthereumAddress(hexString: contractAddress) else {
            contractMessage = "Contract address initializing failed."
            methodNameOnChange(newValue: methodName)
            return
        }
        guard let web3 = web3 else {
            return
        }
        web3.eth.getCode(address: address, block: .latest)
            .done { code in
                if code.hex() == "0x" {
                    contractMessage = "The Address provided is not a contract."
                    contract = nil
                    return
                } else {
                    contractMessage = "The contract address is loaded."
                }
            }
            .catch { error in
                contractMessage = error.localizedDescription
            }
        guard let abi_url = Bundle.main.url(forResource: "abi", withExtension: "json"),
            let abi_data = try? Data(contentsOf: abi_url) else {
            contractMessage = "ABI json file loading failed."
            methodNameOnChange(newValue: methodName)
            return
        }
        do {
            contract = try web3.eth.Contract(json: abi_data, abiKey: nil, address: address)
            methodNameOnChange(newValue: methodName)
        } catch {
            contractMessage = error.localizedDescription
            methodNameOnChange(newValue: methodName)
        }
    }
    
    func methodNameOnChange(newValue: String) {
        guard let contract = contract, contract[newValue] != nil else {
            canCall = false
            method = nil
            return
        }
        canCall = true
        method = contract.methods.first(where: { $0.value.name == newValue })?.value
        guard let method = method else {
            method = nil
            return
        }
        inputs = []
        method.inputs.forEach { param in
            inputs.append((param.name, ""))
        }
        print(inputs)
    }
    
    func callMethod() {
        guard let contract = contract, let method = contract[methodName], let web3 = web3 else {
            callResponse = ""
            return
        }
        firstly {
            web3.eth.accounts()
        }
        .then { accounts in
            method(accounts.first!).call()
        }
        .done { outputs in
            callResponse = outputs.description
        }
        .catch { error in
            callResponse = error.localizedDescription
        }
    }
    
    func methodEstimated() {
        guard let contract = contract, let method = contract[methodName], let web3 = web3 else {
            estimateResponse = ""
            return
        }
        firstly(execute: web3.eth.accounts)
            .then { method(makeParams()).estimateGas(from: $0.first!) }
        .done { gas in
            estimateResponse = "\nThe estimate gas price is \(gas.quantity)"
        }
        .catch { error in
            estimateResponse = error.localizedDescription
        }
    }
    
    func sendMethod() {
        guard let contract = contract, let method = contract[methodName], let web3 = web3 else {
            sendResponse = ""
            return
        }
        firstly(execute: web3.eth.accounts)
            .then { method(makeParams()).send(gasLimit: EthereumQuantity(quantity: 21.gwei), from: $0.first!) }
            .done { sendResponse = $0.hex() }
            .catch { sendResponse = $0.localizedDescription }
    }
    
    private func binding(for index: Int) -> Binding<String> {
        return Binding(get: {
            return inputs[index].1
        }, set: {
            inputs[index].1 = $0
        })
    }
    
    private func makeParams() -> [String] {
        return inputs.map { $0.1 }
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
                VStack {
                    ForEach(0 ..< inputs.count, id: \.self) { index in
                        Text(inputs[index].0)
                            .font(.headline)
                        TextField(inputs[index].0, text: binding(for: index))
                            .lineLimit(2)
                    }
                }
                // Call
                VStack(spacing: 8) {
                    Button("Call", action: callMethod)
                        .disabled(!canCall)
                        .frame(maxWidth: .infinity)
                    Text(callResponse)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Button("Estimate", action: methodEstimated)
                        .disabled(!canCall)
                        .frame(maxWidth: .infinity)
                    Text(estimateResponse)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Button("Send", action: sendMethod)
                        .disabled(!canCall)
                        .frame(maxWidth: .infinity)
                    Text(sendResponse)
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
