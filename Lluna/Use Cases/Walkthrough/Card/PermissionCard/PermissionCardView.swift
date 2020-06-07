//
//  PermissionCardView.swift
//  Lluna
//
//  Created by Developer1 on 02/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import UIKit

protocol PermissionCardViewDelegate {
    func showPermission(_ permission: PermissionContract)
    func skipPermission(_ permission: PermissionContract)
}

protocol PermissionCardViewContract: UIView {
    var delegate: PermissionCardViewDelegate? { get set }
    
    func setModel(_ model: PermissionContract)
}

class PermissionCardView: UIView {
    // MARK: - Outlets
    @IBOutlet weak var backgroundPlaceholderImageView: UIImageView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardContentLabel: UILabel!
    
    @IBOutlet weak var showPermissionAlertButton: UIButton!
    @IBOutlet weak var skipPermission: UIButton!
    
    // MARK: - Vars
    var delegate: PermissionCardViewDelegate?
    private var model: PermissionContract? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bindView()
    }
    
    // MARK: - Setup
    private func setupView() {
        self.backgroundColor = UIColor.white
        
        self.backgroundPlaceholderImageView.image = nil
        self.backgroundPlaceholderImageView.contentMode = .scaleAspectFit
        
        self.cardTitleLabel.textColor = UIColor.darkBlackBlueVlv
        self.cardTitleLabel.text = nil
        
        self.cardContentLabel.textColor = UIColor.darkBlackBlueVlv
        self.cardContentLabel.text = nil
        
        self.showPermissionAlertButton.setTitle(nil, for: .normal)
        self.showPermissionAlertButton.setTitleColor(UIColor.white, for: .normal)
        self.showPermissionAlertButton.backgroundColor = UIColor.dirtBlueGrayVlv
        self.showPermissionAlertButton.titleEdgeInsets = .init(top: 5.0,
                                                               left: 10.0,
                                                               bottom: 5.0,
                                                               right: 10.0)

        
        self.skipPermission.setTitle(nil, for: .normal)
        self.skipPermission.setTitleColor(UIColor.pineGreyVlv, for: .normal)
    }
    
    private func bindView() {
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        self.backgroundPlaceholderImageView.image = UIImage.init(systemName: model?.symbolName ?? "")?.withTintColor(UIColor.lightBlueGrayVlv, renderingMode: .alwaysOriginal)
        self.backgroundPlaceholderImageView.alpha = 0.6
        
        self.cardTitleLabel.text = self.model?.title
        
        self.cardContentLabel.text = self.model?.content
        
        self.showPermissionAlertButton.setTitle("Grant permissions", for: .normal)
        self.showPermissionAlertButton.layer.cornerRadius = self.showPermissionAlertButton.bounds.height * 0.5
        self.showPermissionAlertButton.clipsToBounds = true
        self.showPermissionAlertButton.layoutIfNeeded()
        
        self.skipPermission.setTitle("Skip", for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func showPermissionsButtonPressed(_ sender: Any) {
        guard let permission = self.model else {
            fatalError()
        }
        
        self.delegate?.showPermission(permission)
    }
    
    @IBAction func skipPermissionsButtonPressed(_ sender: Any) {
        guard let permission = self.model else {
            fatalError()
        }

        self.delegate?.skipPermission(permission)
    }
    
    // MARK: - Helper
    private func animateModelChange( completion: (() -> Void)?) {
        UIView.transition(with: self,
                          duration: 0.3, options: .curveEaseOut,
                          animations: {
                            if self.transform == .identity {
                                self.transform = CGAffineTransform.init(translationX: 0, y: self.bounds.height)
                            } else {
                                self.transform = .identity
                            }
        }) { _ in
            completion?()
        }
    }
}

// MARK: - Contract
extension PermissionCardView: PermissionCardViewContract {
    func setModel(_ model: PermissionContract) {
        self.animateModelChange(completion: {
            self.model = model
            self.animateModelChange(completion: nil)
        })
        
    }
}
