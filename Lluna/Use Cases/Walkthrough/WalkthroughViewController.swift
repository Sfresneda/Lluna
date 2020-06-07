//
//  WalkthroughViewController.swift
//  Lluna
//
//  Created by Developer1 on 02/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class WalkthroughViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var cardsContainerView: UIView!
    
    // MARK: - Vars
    private lazy var permissions: [PermissionContract] = []
    private var locationManager: CLLocationManager?
    private var cardView: PermissionCardViewContract?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showNextPermission()
    }
    
    // MARK: - Setup
    private func setupView() {
        self.bindPermissions()

        self.view.backgroundColor = UIColor.lightBlueGrayVlv
        self.cardsContainerView.backgroundColor = UIColor.clear
        
        guard let wrappedCardView = UINib.init(nibName: String(describing: PermissionCardView.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as? PermissionCardView else {
            fatalError()
        }
        
        self.cardView = wrappedCardView
        self.cardView?.delegate = self
        self.cardView?.isHidden = self.permissions.isEmpty
        
        self.cardsContainerView.addSubview(wrappedCardView)
        self.cardView?.fixOnSuperView()
    }
    
    private func bindCard(with model: PermissionContract) {
        DispatchQueue.main.async {
            self.cardView?.setModel(model)
        }
    }
    
    private func bindPermissions() {
        let cameraPermissionsStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let locationPermissionStatus = CLLocationManager.authorizationStatus()
        
        if .authorized != cameraPermissionsStatus {
            self.permissions.append(LlunaPermissions.camera)
        }
        
        if ![.authorizedAlways, .authorizedWhenInUse].contains(where: { $0 == locationPermissionStatus }) {
            self.permissions.append(LlunaPermissions.location)
        }
    }
    
    // MARK: - Helpers
    private func requestCameraPermissions() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { result in
                if result {
                    self.showNextPermission(LlunaPermissions.camera)
                }
            })
            
        case .denied:
            self.showAppSettings()
            
        case .authorized:
            self.showNextPermission(LlunaPermissions.camera)
            
        default:
            break
        }
    }
    
    private func requestLocationPermissions(_ delegateStatus: CLAuthorizationStatus? = nil) {
        if nil == delegateStatus {
            self.locationManager = CLLocationManager.init()
            self.locationManager?.delegate = self
        }
        
        let status = delegateStatus ?? CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            self.locationManager?.requestWhenInUseAuthorization()
            
        case .denied:
            self.showAppSettings()
            
        case .authorizedAlways,
             .authorizedWhenInUse:
            self.showNextPermission(LlunaPermissions.location)
            
        default:
            break
        }
    }
    
    private func showNextPermission(_ currentPermission: PermissionContract? = nil) {
        guard let firstPermission = self.permissions.first else {
            self.navigateToCamera()
            return
        }
        
        if let wrappedCurrentPermission = currentPermission,
            let index = self.permissions.firstIndex(where: { $0.rawValue == wrappedCurrentPermission.rawValue }){
            guard 0 <= index, self.permissions.count - 1 > index else {
                self.navigateToCamera()
                return
            }
            let nextPermission = self.permissions[index + 1]
            self.bindCard(with: nextPermission)
            
        } else {
            self.bindCard(with: firstPermission)
        }
    }
    
    private func navigateToCamera() {
        DispatchQueue.main.async {
            let camera = CameraViewConfigurator.configure()
            camera.modalPresentationStyle = .fullScreen
            camera.modalTransitionStyle = .crossDissolve
            self.present(camera, animated: true, completion: nil)
        }
    }
}

// MARK: - PermissionCardViewDelegate
extension WalkthroughViewController: PermissionCardViewDelegate {
    func showPermission(_ permission: PermissionContract) {
        switch permission {
        case LlunaPermissions.camera:
            self.requestCameraPermissions()
            
        case LlunaPermissions.location:
            self.requestLocationPermissions()
            
        default:
            fatalError("unexpected permission: \(permission.rawValue)")
        }
    }
    
    func skipPermission(_ permission: PermissionContract) {
        self.showNextPermission(permission)
    }
}

extension WalkthroughViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationPermissions(status)
    }
}
