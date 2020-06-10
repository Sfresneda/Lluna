//
//  Moon.swift
//  Lluna
//
//  Created by Developer1 on 04/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import UIKit
import ARKit

protocol MoonContract: SCNNode {
    var isRotating: Bool { get }
    
    func startAnimation()
    func stopAnimation()
}

class Moon: SCNNode {

    // MARK: - Vars
    private let rotateAnimationKey: String = "autoRotate"
    
    var isRotating: Bool = false
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        self.commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonSetup()
    }

    // MARK: - Setup
    private func commonSetup() {
        self.name = "Moon Node"
        
        let entityGeometry = SCNSphere.init(radius: 0.25)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "moon_material")
        entityGeometry.materials = [material]

        self.addPhysics()        
        self.geometry = entityGeometry
    }
    
    private func autoRotationAnimation(_ duration: CFTimeInterval,
                                       repeatCount: Float = .infinity) -> CABasicAnimation{
        let spin = CABasicAnimation(keyPath: "rotation")
        // Use from-to to explicitly make a full rotation around z
        spin.fromValue =  NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(CGFloat(Double.pi*2))))
        spin.duration = duration
        spin.repeatCount = repeatCount
        return spin
    }
    
    private func addPhysics() {
        self.physicsBody = SCNPhysicsBody.init(type: .dynamic, shape: nil)
        self.physicsBody?.mass = 0.0;
        self.physicsBody?.categoryBitMask = CollisionCategory.cube.rawValue
        self.pivot = SCNMatrix4MakeRotation(Float(CGFloat(Double.pi*2)), 1, 0, 0)
    }
}

extension Moon: MoonContract {
    func startAnimation() {
        guard !self.animationKeys.contains(self.rotateAnimationKey) else {
            return
        }
        
        let rotateAnimation = self.autoRotationAnimation(100)
        self.addAnimation(rotateAnimation, forKey: self.rotateAnimationKey)
        
        self.isRotating = true
    }
    
    func stopAnimation() {
        let rotateAnimation = self.autoRotationAnimation(0.5, repeatCount: 0)
        self.addAnimation(rotateAnimation, forKey: self.rotateAnimationKey)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.removeAllAnimations()
        }
        
        self.isRotating = false
    }
}

struct CollisionCategory : OptionSet {
    let rawValue: Int
    
    static let bottom = CollisionCategory(rawValue: 1 << 0)
    static let cube = CollisionCategory(rawValue: 1 << 1)
}
