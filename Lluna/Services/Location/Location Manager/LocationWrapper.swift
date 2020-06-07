//
//  LocationWrapper.swift
//  Lluna
//
//  Created by Developer1 on 07/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationWrapperError: Error {
    case locationServicesDisabled
}

protocol LocationManagerWrapper {
    func startGettingCurrentUserLocation() throws
    func currentLocation() -> CLLocationCoordinate2D?
    
    func getLocationInformation(completion: @escaping ((Location?) -> Void))
}
