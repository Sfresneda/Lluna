//
//  CameraConfigurator.swift
//  Lluna
//
//  Created by Developer1 on 03/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import UIKit

class CameraViewConfigurator {
    static func configure() -> CameraViewController {
        var view: CameraViewContract = CameraViewController.init()
        var presenter: CameraPresenterContract = CameraPresenter.init()
        
        view.presenter = presenter
        presenter.view = view
        
        return view as! CameraViewController
    }
}
