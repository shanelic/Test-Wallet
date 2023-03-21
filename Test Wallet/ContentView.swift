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
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            do {
                let web3 = Web3(rpcURL: "http://127.0.0.1:8545/")
                
                guard let contractAddress = EthereumAddress(hexString: "0x5fbdb2315678afecb367f032d93f642f64180aa3") else {
                    print("::: contract address init failed")
                    return
                }
                
                guard let url = Bundle.main.url(forResource: "abi", withExtension: "json"),
                    let data = try? Data(contentsOf: url) else {
                    print("loading abi failed")
                    return
                }

//                let contractJsonABI = ABI.data(using: .utf8)!
                let contract = try web3.eth.Contract(json: data, abiKey: nil, address: contractAddress)
                
                print("::: contract", contract)
                print("::: contract methods amount", contract.methods.count)
                
                firstly {
                    contract["getMyAddress"]!().call()
                }
                .done { outputs in
//                    print(outputs["_balance"] as? BigUInt)
                    print(outputs)
                }
                .catch { error in
                    print(error)
                }
            } catch {
                print("::: error occurred", error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
