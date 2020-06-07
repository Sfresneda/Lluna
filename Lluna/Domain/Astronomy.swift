//
//  Astronomy.swift
//  Lluna
//
//  Created by Developer1 on 06/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation
struct Astronomy: Codable {
    var location: Location?
    
    let date: String
    let moonrise: String
    let moonset: String
    let moonAltitude: Double
    let moonDistance: Double
    let moonAzimuth: Double
    let moonParallacticAngle: Double
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case date = "date"
        case moonrise = "moonrise"
        case moonset = "moonset"
        case moonAltitude = "moon_altitude"
        case moonDistance = "moon_distance"
        case moonAzimuth = "moon_azimuth"
        case moonParallacticAngle = "moon_parallactic_angle"
    }
}
