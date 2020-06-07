//
//  PermissionWrapper.swift
//  Lluna
//
//  Created by Developer1 on 02/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation

protocol PermissionContract {
    var rawValue: String { get }
    var title: String { get }
    var content: String { get }
    var symbolName: String { get }
}

enum LlunaPermissions: String, CaseIterable, PermissionContract {
    case camera
    case location
    
    var title: String {
        switch self {
        case .camera:
            return "Camera Access"
            
        case .location:
            return "Location Access"
        }
    }
    
    var content: String {
        switch self {
        case .camera:
            return "Lorem ipsum dolor sit, consectetur adipiscing elit.Aenean luctus molestie mauris. \nVitae eleifend nulla ultrices non."
            
        case .location:
            return "Duis pharetra lectus vitae suscipit aliquet.\nNullam laoreet varius tristique. Proin eu accumsan ipsum."
        }
    }
    
    var symbolName: String {
        switch self {
        case .camera:
            return "arkit"
            
        case .location:
            return "location"
        }
    }
}
