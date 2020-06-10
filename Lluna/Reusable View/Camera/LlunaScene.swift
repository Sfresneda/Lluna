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
    func moonTapped()
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
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:)))
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(_:)))
        let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePinch(_:)))
        
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pinchGesture)
        
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
    
    // MARK: - Actions
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        guard nil != self.moonNode,
            self.isGestureOnMoon(sender.location(in: self)) else {
            return
        }
        
        self.moonDelegate?.moonTapped()
    }
    
    @objc
    private func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let moon = self.moonNode,
            self.isGestureOnMoon(sender.location(in: self)),
            !moon.isRotating else {
            return
        }
        
        let translation = sender.translation(in: sender.view!)
        var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
        newAngleY += moon.rotation.y

        moon.eulerAngles.y = newAngleY
    }
    
    @objc
    private func handlePinch(_ sender: UIPinchGestureRecognizer) {
        guard let moon = self.moonNode,
            self.isGestureOnMoon(sender.location(in: self)) else {
            return
        }

        if (.changed == sender.state) {
            let xScale = Float(sender.scale) * moon.scale.x
            let yScale =  Float(sender.scale) * moon.scale.y
            let zScale =  Float(sender.scale) * moon.scale.z

            moon.scale = SCNVector3(x: Float(xScale),
                                    y: Float(yScale),
                                    z: Float(zScale))
            sender.scale = 1
        }
    }
    
    // MARK: - Helper
    private func isGestureOnMoon(_ touchPoint: CGPoint) -> Bool {
        return nil != self.hitTest(touchPoint, options: nil).first
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
