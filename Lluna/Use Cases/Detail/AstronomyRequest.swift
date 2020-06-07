//
//  AstronomyRequest.swift
//  Lluna
//
//  Created by Developer1 on 07/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation

extension DetailViewController {
    struct AstronomyRequest {
        var request: URLRequest
        
        init() {
            let url = kBaseApiPath
            var params: [String: String] = [:]
            let userCoordinates = LocationManager.shared.currentLocation()
            
            params["apiKey"] = kAPIKey
            params["lang"] = Locale.current.languageCode
            
            if let latitude = userCoordinates?.latitude {
                params["lat"] = String(format: "%.4f", latitude)
            }
            
            if let longitude = userCoordinates?.longitude {
                params["long"] = String(format: "%.4f", longitude)
            }
            
            var components = URLComponents.init(url: URL.init(string: url)!,
                                                resolvingAgainstBaseURL: true)!
            components.queryItems = params.filter({ (entry) in
                "" != entry.value
            }).map({ (key, value) in
                URLQueryItem.init(name: key, value: value)
            })
            
            self.request = URLRequest.init(url: components.url!)
        }
    }
}
