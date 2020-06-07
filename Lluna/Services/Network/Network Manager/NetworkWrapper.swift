//
//  NetworkWrapper.swift
//  Lluna
//
//  Created by Developer1 on 06/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation

protocol NetworkWrapperErrorProtocol {
    func getStringError() -> String
}

enum NetworkWrapperError {
    case generalFailure(String)
    case networkingError(String)
    case noResponse
    case badStatus(Int, String)
    case noData
    case dataEncodingError(String)
}

extension NetworkWrapperError: NetworkWrapperErrorProtocol {
    func getStringError() -> String {
        switch self {
        case .badStatus(let errorCode, let errorString):
            return "Error: \(errorString) - \(errorCode)"
        case .dataEncodingError(let errorString):
            return "Error: \(errorString)"
        case .generalFailure(let errorString):
            return "Error: \(errorString)"
        case .networkingError(let errorString):
            return "Error: \(errorString)"
        case .noData:
            return "Error: No Data Available"
        case .noResponse:
            return "Error: Server Does Not Respond"
        }
    }
}

enum NetworkWrapperResponse<T:Codable> {
    case succeed(T)
    case failure(NetworkWrapperError)
}

protocol NetworkWrapper {
    func get<T:Codable>(request: URLRequest, completion: @escaping ((NetworkWrapperResponse<T>) -> ()))
}
