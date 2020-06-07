//
//  PermissionWrapper.swift
//  Lluna
//
//  Created by Developer1 on 02/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation

protocol PermissionContract {
    var title: String { get }
    var content: String { get }
}

enum LlunaPermissions: CaseIterable, PermissionContract {
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
            return "~"
            
        case .location:
            return "~~"
        }
    }
}
