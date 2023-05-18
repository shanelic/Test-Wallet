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
 
 Account #0 : 0x95Ae6CB363A3044a2397aA084426F895f3652E2d (100 ETH)
 Private Key: 0x1bb198ba6b9414b723d99d016a23f53fad4fe4b5cbec70b016be4142fa8680b7
 
 */

enum TestWalletError: Error {
    case general(_ reason: String)
}

struct ContentView: View {
    
    @State private var showScanner = false
    @State private var scannedWalletConnect = ""
    
    @State private var showMethodSheet = false
    
    @State private var privateKey: String = ""
    
    var service = WalletConnectService()
    
    func reset() {
        for wallet in service.getAllConnectedWallets() {
            myPrint(wallet)
        }
        Task.detached {
            await service.disconnectWallet()
        }
    }
    
    @State var alert: Bool = false
    @State var alertBody: String = ""
    
    private func errorHandler(_ error: Error) {
        myPrint(error)
        if case .general(let reason) = error as? TestWalletError {
            alertBody = reason
        } else if let error = error as? RPCResponse<EthereumQuantity>.Error {
            alertBody = error.message
        } else if let error = error as? RPCResponse<EthereumData>.Error {
            alertBody = error.message
        } else if case .invalidInvocation = error as? InvocationError {
            alertBody = (error as! InvocationError).localizedDescription + " invalid invocation"
        } else if case .contractNotDeployed = error as? InvocationError {
            alertBody = (error as! InvocationError).localizedDescription + " contract not deployed"
        } else if case .encodingError = error as? InvocationError {
            alertBody = (error as! InvocationError).localizedDescription + " encoding error"
        } else if case .invalidConfiguration = error as? InvocationError {
            alertBody = (error as! InvocationError).localizedDescription + " invalid configuration"
        } else {
            alertBody = error.localizedDescription
        }
        alert = true
    }
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                HStack {
                    Text("Private Key").bold()
                    Spacer()
                    TextField("Private Key", text: $privateKey)
                }
                Button("Import Wallet") {
                    do {
                        try viewModel.importWallet(privateKey: privateKey)
                    } catch {
                       errorHandler(error)
                    }
                }
                HStack {
                    Text("Select Account").bold()
                    Spacer()
                    Picker("", selection: $viewModel.selectedWalletIndex) {
                        ForEach(0 ..< viewModel.addresses.count, id: \.self) { option in
                            Text(viewModel.addresses[option].hex(eip55: true).simpleAddress)
                        }
                    }
                }
                HStack {
                    Text("Select Network").bold()
                    Spacer()
                    Picker("", selection: $viewModel.selectedNetworkIndex) {
                        ForEach(0 ..< viewModel.networks.count, id: \.self) { option in
                            Text(viewModel.networks[option].name)
                        }
                    }
                }
                HStack {
                    Text("RPC Server").bold()
                    Spacer()
                    Text(viewModel.selectedNetwork.rpcServers.first!.url)
                }
                HStack {
                    Text("Native Token Holding").bold()
                    Spacer()
                    Text("\(viewModel.balance)")
                }
                if !$viewModel.contracts.isEmpty {
                    HStack {
                        Text("Select Contract").bold()
                        Spacer()
                        Picker("", selection: $viewModel.selectedContractIndex) {
                            ForEach(0 ..< viewModel.contracts.count, id: \.self) { option in
                                Text("\(viewModel.contracts[option].name)")
                            }
                        }
                    }
                }
                if !viewModel.constantMethodsInContract.isEmpty {
                    List {
                        ForEach(viewModel.constantMethodsInContract.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            Button(key) {
                                viewModel.selectedMethod = (key, value)
                                showMethodSheet = true
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding()
            .onChange(of: scannedWalletConnect) { newValue in
                guard !newValue.isEmpty else {
                    return
                }
                Task.detached {
                    await service.connectWallet(url: newValue)
                }
                scannedWalletConnect = ""
            }
        }
        .sheet(isPresented: $showMethodSheet, onDismiss: {
            viewModel.selectedMethod = nil
        }) {
            MethodView(viewModel.selectedMethod!, wallet: viewModel.walletAddress)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showScanner) {
            QRScannerView(scanResult: $scannedWalletConnect, shown: $showScanner)
                .presentationDetents([.medium])
        }
        .alert(isPresented: $alert) {
            Alert(
                title: Text("Error"),
                message: Text(alertBody),
                dismissButton: Alert.Button.default(
                    Text("Okay"),
                    action: {
                        self.alertBody = ""
                    }
                )
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
