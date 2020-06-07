//
//  CameraARView.swift
//  Lluna
//
//  Created by Developer1 on 03/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import UIKit
import AVFoundation
import ARKit

protocol CameraARViewDelegate {
    func moonInOnScene()
    func moonTouched()
}

protocol CameraARViewContract: UIView {
    var delegate: CameraARViewDelegate? { get set }
    var isCameraAllowed: Bool { get }
    
    func stopSession()
    func changeNodeAnimationMode(_ mode: MoonAnimationMode)
}

class CameraARView: UIView {
    // MARK: - Vars
    private var llunaScene: LlunaSceneContract?
    internal var isCameraAllowed: Bool {
        return .authorized == AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    var delegate: CameraARViewDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        guard self.isCameraAllowed else {
            return
        }
        
        self.llunaScene = LlunaScene.init(frame: self.frame)
        self.llunaScene?.delegate = self
        self.llunaScene?.moonDelegate = self
        
        guard let arView = self.llunaScene else {
            fatalError()
        }
        
        self.addSubview(arView)
        self.llunaScene?.fixOnSuperView()
    }    
}

// MARK: - Contract
extension CameraARView: CameraARViewContract {    
    func stopSession() {
        self.llunaScene?.session.pause()
    }
    
    func changeNodeAnimationMode(_ mode: MoonAnimationMode) {
        self.llunaScene?.animationStateDidChange(mode)
    }
}

extension CameraARView: LlunaSceneDelegate {
    func moonTouched() {
        self.delegate?.moonTouched()
    }
}

// MARK: - ARSKViewDelegate
extension CameraARView: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        let plane = SCNPlane(width: CGFloat(planAnchor.extent.x), height: CGFloat(planAnchor.extent.z))
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(planAnchor.center.x, 0, planAnchor.center.z)
        
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        node.addChildNode(planeNode)
        self.llunaScene?.insertMoon()
        
        self.delegate?.moonInOnScene()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        if let planeNode = self.llunaScene?.createPlaneNode(anchor: planeAnchor) {
            node.addChildNode(planeNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
}
