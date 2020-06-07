//
//  CameraContract.swift
//  Lluna
//
//  Created by Developer1 on 03/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import Foundation

protocol CameraViewContract {
    var presenter: CameraPresenterContract? { get set }
}

protocol CameraPresenterContract {
    var view: CameraViewContract? { get set }
}
