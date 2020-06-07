//
//  BaseViewController.swift
//  Lluna
//
//  Created by Developer1 on 04/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    open func showError(with message: String,
                           acceptHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        let acceptButton = UIAlertAction.init(title: "Accept",
                                              style: .default, handler: acceptHandler)
        
        alert.addAction(acceptButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    open func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            fatalError()
        }

        DispatchQueue.main.async {
            UIApplication.shared.open(settingsURL)
        }
    }
}
