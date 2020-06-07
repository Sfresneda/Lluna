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
/*
{
    "location": {
        "ip": "31.221.180.166",
        "country_code2": "ES",
        "country_code3": "ESP",
        "country_name": "Spain",
        "state_prov": "Community of Madrid",
        "district": "Arroyo de la Vega",
        "city": "Alcobendas",
        "zipcode": "28108",
        "latitude": 40.5339,
        "longitude": -3.6312
    },
    "date": "2020-06-06",
    "sunrise": "06:44",
    "sunset": "21:43",
    "solar_noon": "14:14",
    "day_length": "14:59",
    "sun_altitude": 59.41049470997526,
    "sun_distance": 1.5178112164792225E8,
    "sun_azimuth": 116.60982978672155,
    "moonrise": "22:43",
    "moonset": "08:06",
    "moon_altitude": -53.16126453885743,
    "moon_distance": 376162.0186877597,
    "moon_azimuth": 286.7184981515819,
    "moon_parallactic_angle": 20.9237361817968
}*/
