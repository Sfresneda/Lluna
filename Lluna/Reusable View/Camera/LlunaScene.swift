//
//  LlunaScene.swift
//  Lluna
//
//  Created by Developer1 on 04/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import UIKit
import ARKit

protocol LlunaSceneDelegate {
    func moonTouched()
    func showError(with message: String)
}

protocol LlunaSceneContract: ARSCNView {
    var moonDelegate: LlunaSceneDelegate? { get set }
    
    func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode
    func insertMoon()
    func animationStateDidChange(_ value: MoonAnimationMode)
}

class LlunaScene: ARSCNView {
    
    // MARK: - Vars
    private var moonNode: MoonContract?
    private var floorMaterial: SCNMaterial?
    private var sessionConfig: ARWorldTrackingConfiguration?
    private let sceneSize = CGSize(width: 2, height: 2)
    
    var moonDelegate: LlunaSceneDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        self.commonSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !touches.isEmpty else {
            return
        }
        
        if 1 == touches.count,
            let touch = touches.first {
            self.handleTap(touch)
            
        } else {
            self.handleMultiTouch(touches)
        }

    }
    
    // MARK: - Setup
    private func commonSetup() {
        guard ARWorldTrackingConfiguration.isSupported else {
            self.moonDelegate?.showError(with: "AR is not supported on this device")
            return
        }

        self.sessionConfig = ARWorldTrackingConfiguration()
        self.sessionConfig?.worldAlignment = .gravity
        self.sessionConfig?.planeDetection = .horizontal
        self.sessionConfig?.isLightEstimationEnabled = true
        
        self.scene.physicsWorld.gravity = SCNVector3Make(0, -400, 0)
        self.antialiasingMode = .multisampling4X
        self.automaticallyUpdatesLighting = false
        self.preferredFramesPerSecond = 60
        self.contentScaleFactor = 1.3
        
        guard let worldSessionConfig = self.sessionConfig else{
            fatalError()
        }
        
        self.session.run(worldSessionConfig, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - Helper
    private func handleTap(_ touch: UITouch) {
        let touchPoint = touch.location(in: self)
        
        guard let result = self.hitTest(touchPoint, options: nil).first else {
            return
        }
        
        if result.node == self.moonNode {
            self.moonDelegate?.moonTouched()
        }
    }
    
    private func handleMultiTouch(_ touches: Set<UITouch>) {
        // do something with multi touch events
    }
}

// MARK: - Contract
extension LlunaScene: LlunaSceneContract {
    func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        let width = anchor.extent.x
        let length = anchor.extent.z
        let planeHeight = 0.01
        let planeGeometry = SCNBox.init(width: CGFloat(width),
                                        height: CGFloat(planeHeight),
                                        length: CGFloat(length),
                                        chamferRadius: 0)

        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3Make(0, Float(-planeHeight / 2), 0)
        planeNode.physicsBody = SCNPhysicsBody(type: .kinematic,
                                               shape: SCNPhysicsShape.init(geometry: planeGeometry,
                                                                           options: nil))
        planeNode.physicsBody?.categoryBitMask = CollisionCategory.bottom.rawValue
        
        self.floorMaterial = SCNMaterial.init()
        self.floorMaterial?.diffuse.contents = UIColor.clear
        self.floorMaterial?.diffuse.wrapS = .repeat
        self.floorMaterial?.diffuse.wrapT = .repeat
        self.floorMaterial?.isDoubleSided = true
        guard let floor = self.floorMaterial else {
            fatalError()
        }
        
        planeGeometry.materials = [floor]
        
        return planeNode
    }
    
    func insertMoon() {
        guard nil == self.moonNode else {
            return
        }
        
        let zOffset: CGFloat = 0.5
        let position: SCNVector3 = SCNVector3.init(0.0,
                                                   0.0,
                                                   0.0 - zOffset)
        
        self.moonNode = Moon.init()
        self.moonNode?.position = position
        guard let moon = self.moonNode else {
            fatalError()
        }
        
        self.scene.rootNode.addChildNode(moon)
    }
    
    func animationStateDidChange(_ mode: MoonAnimationMode) {
        switch mode {
        case .fixed:
            self.moonNode?.stopAnimation()
        case .rotate:
            self.moonNode?.startAnimation()
        }
        
    }
}
