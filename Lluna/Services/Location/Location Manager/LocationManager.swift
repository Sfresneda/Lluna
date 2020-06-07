//
//  LocationManager.swift
//  Lluna
//
//  Created by Developer1 on 07/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    private var locationManager: CLLocationManager = CLLocationManager.init()
    private var userLocation: CLLocation?
    
    
    static var shared: LocationManager = LocationManager.init()
}

extension LocationManager: LocationManagerWrapper {
    func startGettingCurrentUserLocation() throws {
        guard CLLocationManager.locationServicesEnabled() else {
            throw LocationWrapperError.locationServicesDisabled
        }
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.startUpdatingLocation()
    }
    
    func currentLocation() -> CLLocationCoordinate2D? {
        return self.userLocation?.coordinate
    }
    
    func getLocationInformation(completion: @escaping ((Location?) -> Void)) {
        guard let userLocation = self.userLocation else {
            completion(nil)
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                debugPrint(" ⚠️🌎Unable to reverse geocode \(String(describing: error?.localizedDescription))")
                return
            }

            let userLocation: Location = Location.init(ipAddress: nil,
                                                       contryCode: placemark.isoCountryCode,
                                                       countryName: placemark.country,
                                                       stateProvince: placemark.administrativeArea,
                                                       city: placemark.locality,
                                                       latitude: userLocation.coordinate.latitude,
                                                       longitude: userLocation.coordinate.longitude)
            
            completion(userLocation)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("⚠️🌎 location error: \(error.localizedDescription)")
    }
}
