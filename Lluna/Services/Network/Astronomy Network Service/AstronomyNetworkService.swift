//
//  AstronomyNetworkService.swift
//  Lluna
//
//  Created by Developer1 on 06/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation

final class AstronomyNetworkService {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

extension AstronomyNetworkService: AstronomyNetworkServiceProtocol {
    func getAstronomyData(request: URLRequest, completion: @escaping ((AstronomyNetworkResponse) -> ())) {
        
        self.networkManager.get(request: request) { (response: NetworkWrapperResponse<Astronomy>) in
            switch response {
            case .failure(let wrapperError):
                completion(.failure(wrapperError))
            case .succeed(let requestModel):
                completion(.succeed(model: requestModel))
            }
        }
    }
}
