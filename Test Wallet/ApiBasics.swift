//
//  ApiBasics.swift
//  Test Wallet
//
//  Created by Shane Li on 2023/5/15.
//

import Foundation
import Moya
import CombineMoya

// MARK: API singleton basic structure
final public class API {
    public static let shared = API()
    private init() {}
    private let provider = MoyaProvider<MultiTarget>()
    
    func request<Request: DecodableResponseTargetType>(_ request: Request) -> AnyPublisher<Request.ResponseType, MoyaError> {
        let target = MultiTarget.init(request)
        return provider
            .requestPublisher(target)
            .filterSuccessfulStatusCodes()
            .map(Request.ResponseType.self)
    }
}

protocol DecodableResponseTargetType: TargetType {
    associatedtype ResponseType: Decodable
}
