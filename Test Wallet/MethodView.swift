//
//  MethodView.swift
//  Test Wallet
//
//  Created by RBLabs RD - Shane on 2023/5/18.
//

import SwiftUI
import Web3
import Web3ContractABI

struct MethodView: View {
    
    init(_ method: (String, SolidityFunction), wallet: EthereumAddress? = nil) {
        self.methodName = method.0
        self.method = method.1
        inputs = Array<String>(repeating: "", count: method.1.inputs.count)
        self.wallet = wallet
    }
    
    private let methodName: String
    private let method: SolidityFunction
    private let wallet: EthereumAddress?
    
    @State private var inputs: [String] = []
    
    @State private var showAlert: Bool = false
    @State private var result: String = ""
    
    var body: some View {
        Form {
            Text(methodName)
                .font(.title2)
            ForEach(0 ..< method.inputs.count, id: \.self) { index in
                TextField(method.inputs[index].name, text: binding(index: index))
            }
            Button("Call") {
                if inputs.filter({ $0.isEmpty }).isEmpty {
                    Task {
                        if let response = try? await (method as? BetterInvocation)?
                            .betterInvoke(inputs)
                            .call()
                            .async()
                        {
                            myPrint("call of method \(methodName) with inputs \(inputs) got response", response)
                            guard let outputs = method.outputs else { return }
                            var result = ""
                            for (index, output) in outputs.enumerated() {
                                switch method.outputs![index].type {
                                case .address:
                                    result += "\(output.name): \((response[output.name] as! EthereumAddress).hex(eip55: true))\n"
                                default:
                                    result += "\(output.name): \(response[output.name]!)\n"
                                }
                            }
                            self.result = result
                            self.showAlert = true
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            for index in 0 ..< method.inputs.count {
                switch method.inputs[index].type {
                case .type(.address):
                    if let address = wallet?.hex(eip55: true) {
                        inputs[index] = address
                    }
                case .type(.uint), .type(.int):
                    inputs[index] = "0"
                case .type(.bool):
                    inputs[index] = "True"
                case .type(.bytes):
                    inputs[index] = "0x000000000000000000000000000000"
                default:
                    break
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(result)
            )
        }
    }
    
    private func binding(index: Int) -> Binding<String> {
        Binding<String>(
            get: {
                return inputs[index]
            },
            set: {
                inputs[index] = $0
            }
        )
    }
    
    private func binding(index: Int) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                return inputs[index] == "True" ? true : false
            },
            set: {
                inputs[index] = $0 ? "True" : "False"
            }
        )
    }
    
    private func bindingInt(index: Int) -> Binding<Int> {
        Binding<Int>(
            get: {
                return Int(inputs[index]) ?? 0
            },
            set: {
                inputs[index] = "\($0)"
            }
        )
    }
    
    private func convertInputs(_ inputs: [String]) throws -> [ABIEncodable] {
        var outputs: [ABIEncodable] = []
        for (index, input) in inputs.enumerated() {
            switch method.inputs[index].type {
            case .type(.address):
                if let address = EthereumAddress(hexString: input) {
                    outputs.append(address)
                }
            case .type(.uint):
                if let uint256 = BigUInt(input, radix: 10) {
                    outputs.append(uint256)
                }
            case .type(.int):
                if let int256 = BigInt(input, radix: 10) {
                    outputs.append(int256)
                }
            case .type(.bool):
                outputs.append(input == "True")
            case .type(.bytes):
                if let data = input.data(using: .utf8) {
                    outputs.append(data)
                }
            default:
                outputs.append(input)
            }
        }
        if inputs.count == outputs.count {
            return outputs
        } else {
            throw TestWalletError.general("some of inputs convert failed.")
        }
    }
}

//struct MethodView_Previews: PreviewProvider {
//    static var previews: some View {
//        MethodView()
//    }
//}
