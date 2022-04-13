//
//  TYButton_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import UIKit

/// 按钮状态
public enum TYButtonStatusEnum_ty {
    case normal, touchDown, disable
}

/// 按钮风格样式
public enum TYButtonType_ty {
    case normal, theme, second
}

@IBDesignable
open class TYButton_ty: UIButton {
    public var status: TYButtonStatusEnum_ty = .normal {
        didSet {
            self.updateStatus()
        }
    }
    public var type_ty: TYButtonType_ty
    public var isAnimation: Bool
    /// 禁用状态下按钮的透明度
    public let disableOpacity_ty: Float = 0.3
    
    public init(_ type: TYButtonType_ty = .normal, animation: Bool = true) {
        self.type_ty     = type
        self.isAnimation = animation
        super.init(frame: .zero)
        self.bindProperty_ty()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    // MARK: ==== Layout ====
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateStatus()
    }
    
    public func updateStatus() {
        switch self.status {
        case .normal:
            self.isEnabled = true
            if self.type_ty == .theme {
                self.backgroundColor = .theme_ty
            } else {
                self.layer.opacity   = 1.0
            }
        case .touchDown:
            break
        case .disable:
            self.isEnabled = false
            if self.type_ty == .theme {
                self.backgroundColor = .gray
            } else {
                self.layer.opacity   = self.disableOpacity_ty
            }
        }
    }
    
    // MARK: ==== Event ====
    public func bindProperty_ty() {
        switch type_ty {
        case .normal:
            self.setTitleColor(UIColor.black, for: .normal)
        case .theme:
            self.setTitleColor(UIColor.white, for: .normal)
            self.layer.cornerRadius  = AdaptSize_ty(5)
            self.layer.masksToBounds = true
            self.backgroundColor     = UIColor.theme_ty
        case .second:
            self.setTitleColor(UIColor.white, for: .normal)
            self.layer.cornerRadius  = AdaptSize_ty(5)
            self.layer.masksToBounds = true
            self.backgroundColor     = UIColor.white
            self.layer.borderColor   = UIColor.theme_ty.cgColor
            self.layer.borderWidth   = AdaptSize_ty(1)
            self.setTitleColor(UIColor.theme_ty, for: .normal)
        }
        self.addTarget(self, action: #selector(touchDown_ty(sender:)), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp_ty(sender:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp_ty(sender:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(touchUp_ty(sender:)), for: .touchCancel)
    }
    
    @objc private func touchDown_ty(sender: UIButton) {
        self.isEnabled = true
        if self.type_ty != .normal {
            self.layer.opacity = 0.7
        }
        guard self.isAnimation else { return }
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values        = [0.9]
        animation.duration      = 0.1
        animation.autoreverses  = false
        animation.fillMode      = .forwards
        animation.isRemovedOnCompletion = false
        sender.layer.add(animation, forKey: nil)
    }
    
    @objc private func touchUp_ty(sender: UIButton) {
        if type_ty != .normal {
            self.layer.opacity = 1.0
        }
        guard self.isAnimation else { return }
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values        = [1.1, 0.95, 1.0]
        animation.duration      = 0.2
        animation.autoreverses  = false
        animation.fillMode      = .forwards
        animation.isRemovedOnCompletion = false
        sender.layer.add(animation, forKey: nil)
    }
    
    // TODO: SB编辑
    @IBInspectable
    open var cornerRadius: CGFloat = 0.0 {
        willSet {
            layer.cornerRadius  = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
