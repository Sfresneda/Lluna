//
//  ChangeARModeButton.swift
//  Lluna
//
//  Created by Developer1 on 03/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import UIKit

enum MoonAnimationMode {
    case fixed
    case rotate
    
    var title: String {
        switch self {
        case .fixed:
            return "Fixed Mode"
        case .rotate:
            return "Auto Rotate Mode"
        }
    }
}

class ChangeARModeButton: UIButton {
    
    // MARK: - Vars
    var mode: MoonAnimationMode = .fixed
    var nextMode: MoonAnimationMode {
        return self.mode == .fixed ? .rotate : .fixed
    }
          
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                if self.isEnabled {
                    self.alpha = 1
                    self.transform = CGAffineTransform.identity
                } else {
                    self.alpha = 0.5
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupButton()
    }
    
    // MARK: - Setup
    private func setupButton() {
        self.addTarget(self, action: #selector(changeMode(_:)), for: .touchUpInside)
        
        self.updateImageButton()
    }
    
    private func updateImageButton() {
        self.isEnabled = false
        
        switch self.mode {
        case .fixed:
            self.setImage(UIImage.init(systemName: "moon.zzz")?
                .withTintColor(UIColor.white, renderingMode: .alwaysOriginal),
                          for: .normal)
        case .rotate:
            self.setImage(UIImage.init(systemName: "moon")?
                .withTintColor(UIColor.white, renderingMode: .alwaysOriginal),
                          for: .normal)
        }
    }
    
    // MARK: - Actions
    @objc
    private func changeMode(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        }
        
        self.mode = .fixed == self.mode ? .rotate : .fixed
        self.updateImageButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isEnabled = true
        }
    }
}
