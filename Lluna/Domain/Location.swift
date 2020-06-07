//
//  Location.swift
//  Lluna
//
//  Created by Developer1 on 06/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation

struct Location: Codable {
    let ipAddress: String?
    let contryCode: String?
    let countryName: String?
    let stateProvince: String?
    let city: String?
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case ipAddress = "ip"
        case contryCode = "country_code2"
        case countryName = "country_name"
        case stateProvince = "state_prov"
        case city = "city"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
