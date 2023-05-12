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
    
    @State private var showScanner = false
    @State private var scannedWalletConnect = ""
    
    @State var rpcUrl = "http://10.14.67.4"
    @State var rpcPort = "7000"
    
    @State var web3: Web3?
    @State var contractAddress = "0xa4c02eC587071d37eEbb345332942E99E0499eD4"
    @State var erc20Contract: GenericERC20Contract?
    @State var erc721Contract: GenericERC721Contract?
    @State var dynamicContract: DynamicContract?
    
    @State var contractMessage = ""
    
    @State var methodResponse = ""
    
    @State var transactionPromise:  SolidityInvocation? // Promise<EthereumData>?
    @State var transactionResponse = ""
    
    @State var myPrivateKey = MY_PRIVATE_KEY
    @State var otherAddress = "0x0E186C75C9F9c83F04F523FE34D3707Ba0D32fF3"
    
    var service = WalletConnectService()
    
    func reset() {
        
        scannedWalletConnect = ""
        rpcUrl = "http://10.14.67.4"
        rpcPort = "7000"
        
        web3 = nil
        
        contractAddress = "0xa4c02eC587071d37eEbb345332942E99E0499eD4"
        
        erc721Contract = nil
        erc20Contract = nil
        dynamicContract = nil
        contractMessage = ""
        methodResponse = ""
        
        transactionPromise = nil
        transactionResponse = ""
        
        for wallet in service.getAllConnectedWallets() {
            myPrint(wallet)
        }
        Task.detached {
            await service.disconnectWallet()
        }
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
                    erc20Contract = web3.eth.Contract(type: GenericERC20Contract.self)
                    
                    erc20Contract?.symbol().call()
                        .done { data in
                            myPrint("erc20 contract symbol", data)
                        }
                        .catch { error in
                            myPrint("error on erc20", errorHandler(error))
                        }
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
    
    func getMyTokenIdList() {
        guard
            let dynamicContract = dynamicContract,
            let myPrivateKey = try? EthereumPrivateKey(hexPrivateKey: myPrivateKey),
            let tokensOfOwnerMethod = dynamicContract["tokensOfOwner"]
        else {
            methodResponse = "get tokens of owner initializing failed."
            return
        }
        tokensOfOwnerMethod(myPrivateKey.address)
            .call()
            .done { data in
                methodResponse = data.description
            }
            .catch { error in
                methodResponse = errorHandler(error)
            }
    }
    
    func estimateSetAuthorized() {
        guard
            let dynamicContract = dynamicContract,
            let myPrivateKey = try? EthereumPrivateKey(hexPrivateKey: myPrivateKey),
            let setAuthorizedMethod = dynamicContract["setAuthorized"]
        else {
            methodResponse = "estimate set authorized initializing failed."
            return
        }
        setAuthorizedMethod(myPrivateKey.address, 1)
            .estimateGas(from: myPrivateKey.address)
            .done { qty in
                methodResponse = "\(qty.quantity) gas will be used to set an address as authorized."
                transactionPromise = setAuthorizedMethod(myPrivateKey.address, 1)
            }
            .catch { error in
                methodResponse = errorHandler(error)
            }
    }
    
    func estimateMintNft() {
        guard
            let dynamicContract = dynamicContract,
            let myPrivateKey = try? EthereumPrivateKey(hexPrivateKey: myPrivateKey),
            let mintMethod = dynamicContract["mint"]
        else {
            methodResponse = "estimate mint initializing failed."
            return
        }
        mintMethod(myPrivateKey.address, 1)
            .estimateGas(from: myPrivateKey.address)
            .done { qty in
                methodResponse = "\(qty.quantity) gas will be used to mint a NFT."
                transactionPromise = mintMethod(myPrivateKey.address, 1)
            }
            .catch { error in
                methodResponse = errorHandler(error)
            }
    }
    
    func estimateTransfer() {
        guard
            let erc721Contract = erc721Contract,
            let myPrivateKey = try? EthereumPrivateKey(hexPrivateKey: myPrivateKey),
            let otherAddress = EthereumAddress(hexString: otherAddress)
        else {
            methodResponse = "Initializing failed."
            return
        }
        erc721Contract
            .transferFrom(from: myPrivateKey.address, to: otherAddress, tokenId: 3)
            .estimateGas(from: myPrivateKey.address)
            .done { qty in
                methodResponse = "\(qty.quantity) gas will be used to transfer a NFT."
                transactionPromise = erc721Contract
                    .transferFrom(from: myPrivateKey.address ,to: otherAddress, tokenId: 3)
            }
            .catch { error in
                methodResponse = errorHandler(error)
            }
    }
    
    func estimateSetApproval() {
        guard
            let erc721Contract = erc721Contract,
            let myPrivateKey = try? EthereumPrivateKey(hexPrivateKey: myPrivateKey),
            let otherAddress = EthereumAddress(hexString: otherAddress)
        else {
            methodResponse = "Initializing failed."
            return
        }
        erc721Contract.approve(to: otherAddress, tokenId: 11)
            .estimateGas(from: myPrivateKey.address)
            .done { qty in
                methodResponse = "\(qty.quantity) gas will be used to set approval."
                transactionPromise = erc721Contract
                    .approve(to: otherAddress, tokenId: 11)
            }
            .catch { error in
                methodResponse = errorHandler(error)
            }
    }
    
    func executeEstimatedMethod() {
        guard
            let web3 = web3,
            let transactionPromise = transactionPromise,
            let myPrivateKey = try? EthereumPrivateKey(hexPrivateKey: myPrivateKey)
        else {
            transactionResponse = "execution initializing failed."
            return
        }
        var tempQty = EthereumQuantity(quantity: 0)
        var tempData: EthereumTransactionReceiptObject!
        web3.eth.getBalance(address: myPrivateKey.address, block: .latest)
            .then { qty in
                tempQty = qty
                return transactionPromise.send(from: myPrivateKey.address)
            }
            .then(web3.eth.getTransactionReceipt)
            .then { data in
                guard let data = data else {
                    throw TestWalletError.general("the transaction failed.")
                }
                tempData = data
                
                return web3.eth.getBalance(address: myPrivateKey.address, block: .latest)
            }
            .done { qty in
                let etherLoss = tempQty.quantity - qty.quantity
                let gasPrice = etherLoss / tempData.cumulativeGasUsed.quantity
                let etherUsed = Double(tempData.cumulativeGasUsed.quantity) * Double(gasPrice) / Double(1.gwei)
                myPrint("gas used is \(tempData.cumulativeGasUsed.quantity) @ \(gasPrice) wei, so the ether used is \(etherUsed) gwei!")
                transactionResponse = "\(etherUsed) gwei used to complete this transaction, congrats!"
            }
            .catch { error in
                transactionResponse = errorHandler(error)
            }
            .finally {
                self.transactionPromise = nil
            }
    }
    
    private func errorHandler(_ error: Error) -> String {
        myPrint(error)
        transactionPromise = nil
        if case .general(let reason) = error as? TestWalletError {
            return reason
        } else if let error = error as? RPCResponse<EthereumQuantity>.Error {
            return error.message
        } else if let error = error as? RPCResponse<EthereumData>.Error {
            return error.message
        } else if case .invalidInvocation = error as? InvocationError {
            return (error as! InvocationError).localizedDescription + " invalid invocation"
        } else if case .contractNotDeployed = error as? InvocationError {
            return (error as! InvocationError).localizedDescription + " contract not deployed"
        } else if case .encodingError = error as? InvocationError {
            return (error as! InvocationError).localizedDescription + " encoding error"
        } else if case .invalidConfiguration = error as? InvocationError {
            return (error as! InvocationError).localizedDescription + " invalid configuration"
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
                VStack(alignment: .leading) {
                    Text("Other Address")
                        .font(.headline)
                    TextField("Wallet Address", text: $otherAddress)
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
                    Button("Get Owned NFT Token ID List", action: getMyTokenIdList)
                        .frame(maxWidth: .infinity)
                    Button("Estimate Gas For SetAuthorized", action: estimateSetAuthorized)
                        .frame(maxWidth: .infinity)
                    Button("Estimate Gas For Mint", action: estimateMintNft)
                        .frame(maxWidth: .infinity)
                    Button("Estimate Gas For Transfer", action: estimateTransfer)
                        .frame(maxWidth: .infinity)
                    Button("Estimate Gas For setApproval", action: estimateSetApproval)
                        .frame(maxWidth: .infinity)
                    Text(methodResponse)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Button("Do What Just Estimated", action: executeEstimatedMethod)
                        .disabled(transactionPromise == nil)
                    Text(transactionResponse)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                // Reset
                VStack {
                    Button("RESET", action: reset)
                }
                // qrcode scanner
                VStack {
                    Button("QRCode", action: {
                        showScanner.toggle()
                    })
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
        .onChange(of: scannedWalletConnect) { newValue in
            guard !newValue.isEmpty else {
                return
            }
            Task.detached {
                await service.connectWallet(url: newValue)
            }
            scannedWalletConnect = ""
        }
        .sheet(isPresented: $showScanner) {
            QRScannerView(scanResult: $scannedWalletConnect, shown: $showScanner)
                .presentationDetents([.medium])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
