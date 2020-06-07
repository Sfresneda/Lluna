//
//  AstronomyNetworkProtocol.swift
//  Lluna
//
//  Created by Developer1 on 06/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation

enum AstronomyNetworkResponse {
    case succeed(model: Astronomy)
    case failure(NetworkWrapperError)
}

protocol AstronomyNetworkServiceProtocol {
    func getAstronomyData(request: URLRequest,
                                       completion: @escaping ((AstronomyNetworkResponse) -> ()))
}
