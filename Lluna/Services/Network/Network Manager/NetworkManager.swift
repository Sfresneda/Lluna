//
//  NetworkManager.swift
//  Lluna
//
//  Created by Developer1 on 06/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation

final class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    
    let session: URLSession
    
    private init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 10

        session = URLSession.init(configuration: sessionConfiguration)
    }
}

extension NetworkManager: NetworkWrapper {
    func get<T>(request: URLRequest, completion: @escaping ((NetworkWrapperResponse<T>) -> ())) where T : Codable {
        let task: URLSessionDataTask = self.session.dataTask(with: request) { (data, response, error) in
            var taskResult: NetworkWrapperResponse<T> = .failure(.generalFailure("Unkown Error"))
            
            defer {
                DispatchQueue.main.async {
                    completion(taskResult)
                }
            }
            
            guard nil == error else {
                taskResult = .failure(.networkingError(error!.localizedDescription))
                return
            }
            guard let wrappedResponse = response as? HTTPURLResponse else {
                taskResult = .failure(.noResponse)
                return
            }
            guard (200 ..< 300) ~= wrappedResponse.statusCode else {
                taskResult = .failure(.badStatus(wrappedResponse.statusCode, wrappedResponse.description))
                return
            }
            guard let wrappedData = data else {
                taskResult = .failure(.noData)
                return
            }
            
            do {
                let validResponse = try JSONDecoder().decode(T.self, from: wrappedData)
                taskResult = .succeed(validResponse)
            } catch let encodingError {
                taskResult = .failure(.dataEncodingError(encodingError.localizedDescription))
            }
        }
        
        task.resume()
    }
}
