//
//  CameraViewController.swift
//  Lluna
//
//  Created by Developer1 on 03/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import UIKit

class CameraViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var noPermissionLabel: UILabel!
    @IBOutlet weak var noPermissionButton: UIButton!
    
    @IBOutlet weak var changeAnimationButton: ChangeARModeButton!
    @IBOutlet weak var changeAnimationIndicatorContainerView: UIVisualEffectView!
    @IBOutlet weak var changeAnimationIndicatorLabel: UILabel!
    
    // MARK: - Vars
    private var cameraARView: CameraARViewContract?
    var presenter: CameraPresenterContract?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.initUserLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNoPermissionsUI()
        self.checkAndUpdateCameraViewVisibility()
    }
    
    // MARK: - Setup
    private func setupView() {
        self.view.backgroundColor = UIColor.lightBlueGrayVlv
        
        self.setupCameraARView()
        
        self.noPermissionLabel.text = "No Camera / Location Permissions Authorized"
        self.noPermissionLabel.isHidden = true
        self.noPermissionLabel.textAlignment = .center
        self.noPermissionLabel.textColor = UIColor.darkBlackBlueVlv
        
        self.noPermissionButton.setTitle("Check in Settings", for: .normal)
        self.noPermissionButton.setTitleColor(UIColor.white, for: .normal)
        self.noPermissionButton.isHidden = true
        self.noPermissionButton.backgroundColor = UIColor.dirtBlueGrayVlv
        self.noPermissionButton.layer.cornerRadius = self.noPermissionButton.bounds.height * 0.5
        self.noPermissionButton.clipsToBounds = true
        self.noPermissionButton.titleEdgeInsets = .init(top: 5.0,
                                                        left: 10.0,
                                                        bottom: 5.0,
                                                        right: 10.0)
        
        self.changeAnimationButton.setTitle(nil, for: .normal)
        self.changeAnimationButton.backgroundColor = UIColor.dirtBlueGrayVlv
        self.changeAnimationButton.layer.cornerRadius = self.changeAnimationButton.bounds.width * 0.5
        self.changeAnimationButton.clipsToBounds = true
        self.changeAnimationButton.isEnabled = false
        
        self.changeAnimationIndicatorContainerView.layer.cornerRadius = self.changeAnimationIndicatorContainerView.bounds.height * 0.5
        self.changeAnimationIndicatorContainerView.clipsToBounds = true
        self.changeAnimationIndicatorContainerView.alpha = 0
        
        self.changeAnimationIndicatorLabel.text = nil
        self.changeAnimationIndicatorLabel.textColor = UIColor.blackOnyxVlv
    }
    
    private func setupCameraARView() {
        self.cameraARView = CameraARView.init()
        self.cameraARView?.backgroundColor = UIColor.clear
        
        guard let changeVisualizationButtonIndex = self.view.subviews.firstIndex(of: self.changeAnimationButton),
            let wrappedCameraARView = self.cameraARView else {
                fatalError()
        }
        
        self.view.insertSubview(wrappedCameraARView, at: changeVisualizationButtonIndex)
        self.cameraARView?.fixOnSuperView()
        self.cameraARView?.isHidden = true
        self.cameraARView?.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func checkInSettingsButtonPressed(_ sender: Any) {
        self.showAppSettings()
    }
    @IBAction func changeModeButtonPressed(_ sender: ChangeARModeButton) {
        self.cameraARView?.changeNodeAnimationMode(sender.nextMode)
        self.showAnimationIndicator(with: sender.nextMode.title)
    }
    
    // MARK: - Helpers
    private func isAppPermissionsAuthorized() -> Bool {
        return self.cameraARView?.isCameraAllowed ?? false
    }
    
    private func checkAndUpdateCameraViewVisibility() {
        let isHiddenCameraUI = !self.isAppPermissionsAuthorized()
        self.cameraARView?.isHidden = isHiddenCameraUI
        self.changeAnimationButton.isHidden = isHiddenCameraUI
        self.changeAnimationIndicatorContainerView.isHidden = isHiddenCameraUI
    }
    
    private func setupNoPermissionsUI() {
        let isVisibleNoPermissionsElements = self.isAppPermissionsAuthorized()
        
        self.noPermissionLabel.isHidden = isVisibleNoPermissionsElements
        self.noPermissionButton.isHidden = isVisibleNoPermissionsElements
    }
    
    private func showAnimationIndicator(with text: String) {
        DispatchQueue.main.async {
            self.changeAnimationIndicatorLabel.text = text
            
            UIView.animate(withDuration: 0.4,
                           animations: {
                            self.changeAnimationIndicatorContainerView.alpha = 1
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.hideAnimationIndicator()
                }
            }
        }
    }
    private func hideAnimationIndicator() {
        UIView.animate(withDuration: 0.2) {
            self.changeAnimationIndicatorContainerView.alpha = 0
        }
    }
    
    private func changeAnimationModeButtonEnabledState() {
        DispatchQueue.main.async {
            self.changeAnimationButton.isEnabled = !self.changeAnimationButton.isEnabled
        }
    }
    
    private func initUserLocation() {
        do {
            try LocationManager.shared.startGettingCurrentUserLocation()
        } catch let error {
            print("⚠️ \(error.localizedDescription)")
        }
    }
}

// MARK: - Contract
extension CameraViewController: CameraViewContract {}

// MARK: - CameraARViewDelegate
extension CameraViewController: CameraARViewDelegate {
    func moonInOnScene() {
        self.changeAnimationModeButtonEnabledState()
        self.showAnimationIndicator(with: self.changeAnimationButton.mode.title)
    }
    
    func moonTouched() {
        let detailView = DetailViewController.init()
        detailView.modalPresentationStyle = .pageSheet
        self.present(detailView, animated: true, completion: nil)
    }
}
