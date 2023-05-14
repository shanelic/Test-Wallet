//
//  EtherscanService.swift
//  Test Wallet
//
//  Created by Shane Li on 2023/5/13.
//

import Foundation
import Combine
import Moya
import CombineMoya

// MARK: Etherscan APIs

protocol EtherscanTargetType: DecodableResponseTargetType {}

extension EtherscanTargetType {
    
    var baseURL: URL {
        URL(string: "https://api.etherscan.io/api")!
    }
    
    var headers: [String: String]? {
        [
            "Content-type": "application/json",
            "Accept": "application/json",
        ]
    }
    
    fileprivate var apiKey: String {
        ETHERSCAN_API_KEY
    }
}

struct EtherscanResponse<T>: Codable where T: Codable {
    let status: String
    let message: String
    let result: T
}

enum EtherscanAPIs {}

// MARK: Account

extension EtherscanAPIs {
    
    struct Erc20TokenHolding: EtherscanTargetType {
        typealias ResponseType = EtherscanResponse<[Etherscan.Erc20Token]>
        var method: Moya.Method { return .get }
        var path: String { return "/" }
        var task: Task {
            return .requestParameters(
                parameters: [
                    "module": "account",
                    "action": "addresstokenbalance",
                    "address": address,
                    "page": page,
                    "offset": offset,
                    "apikey": apiKey,
                ],
                encoding: URLEncoding.queryString
            )
        }
        
        private var address: String
        private var page: String
        private var offset: String
        
        /// - Parameter address: the address querying
        /// - Parameter page: the current page number, `1` by default
        /// - Parameter offset: the current page size, `100` by default
        init(address: String, page: Int = 1, offset: Int = 100) {
            self.address = address
            self.page = "\(page)"
            self.offset = "\(offset)"
        }
    }
    
    struct Erc721TokenHolding: EtherscanTargetType {
        typealias ResponseType = EtherscanResponse<[Etherscan.Erc721Token]>
        var method: Moya.Method { .get }
        var path: String { "/" }
        var task: Task { .requestParameters(
            parameters: [
                "module": "account",
                "action": "addresstokennftbalance",
                "address": address,
                "page": page,
                "offset": offset,
                "apikey": apiKey,
            ],
            encoding: URLEncoding.queryString
        ) }
        
        private var address: String
        private var page: String
        private var offset: String
        
        /// - Parameter address: the address querying
        /// - Parameter page: the current page number, `1` by default
        /// - Parameter offset: the current page size, `100` by default
        init(address: String, page: Int = 1, offset: Int = 100) {
            self.address = address
            self.page = "\(page)"
            self.offset = "\(offset)"
        }
    }
}
