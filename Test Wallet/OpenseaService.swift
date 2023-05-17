//
//  OpenseaService.swift
//  Test Wallet
//
//  Created by Shane Li on 2023/5/13.
//

import Foundation
import Moya

// MARK: Opensea APIs

protocol OpenseaTargetType: DecodableResponseTargetType {}

extension OpenseaTargetType {
    
    var baseURL: URL {
        URL(string: "https://api.opensea.io/api")!
    }
    
    var headers: [String : String]? {
        [
            "Accept": "application/json",
            "X-API-KEY": apiKey
        ]
    }
    
    fileprivate var apiKey: String {
        OPENSEA_API_KEY
    }
}

struct OpenseaResponse<T>: Codable where T: Codable {
    
}

enum OpenseaAPIs {}

// MARK: Assets

extension OpenseaAPIs {
    
    struct retrieveCollections: OpenseaTargetType {
        typealias ResponseType = [Opensea.Collection]
        var method: Moya.Method { .get }
        var path: String { "/v1/collections" }
        var task: Task {
            .requestParameters(
                parameters: [
                    "asset_owner": address,
                    "offset": offset,
                    "limit": limit,
                ],
                encoding: URLEncoding.queryString
            )
        }
        
        private let address: String
        private let offset: Int
        private let limit: Int
        
        init(address: String, offset: Int = 0, limit: Int = 300) {
            self.address = address
            self.offset = offset
            self.limit = limit
        }
    }
    
}
