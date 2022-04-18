//
//  TYButton_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import UIKit

/// 按钮状态
public enum TYButtonStatusEnum_ty {
    case normal_ty, touchDown_ty, disable_ty
}

/// 按钮风格样式
public enum TYButtonType_ty {
    case normal_ty, theme_ty, second_ty
}

@IBDesignable
public class TYButton_ty: UIButton {
    public var status_ty: TYButtonStatusEnum_ty = .normal_ty {
        didSet {
            self.updateStatus_ty()
        }
    }
    public var type_ty: TYButtonType_ty
    public var isAnimation_ty: Bool
    /// 禁用状态下按钮的透明度
    public let disableOpacity_ty: Float = 0.3
    
    public init(_ type_ty: TYButtonType_ty = .normal_ty, animation_ty: Bool = true) {
        self.type_ty        = type_ty
        self.isAnimation_ty = animation_ty
        super.init(frame: .zero)
        self.bindProperty_ty()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeTarget(self, action: #selector(touchDown_ty(sender_ty:)), for: .touchDown)
        self.removeTarget(self, action: #selector(touchUp_ty(sender_ty:)), for: .touchUpInside)
        self.removeTarget(self, action: #selector(touchUp_ty(sender_ty:)), for: .touchUpOutside)
        self.removeTarget(self, action: #selector(touchUp_ty(sender_ty:)), for: .touchCancel)
    }
    
    // MARK: ==== Layout ====
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateStatus_ty()
    }
    
    public func updateStatus_ty() {
        switch self.status_ty {
        case .normal_ty:
            self.isEnabled = true
            if self.type_ty == .theme_ty {
                self.backgroundColor = .theme_ty
            } else {
                self.layer.opacity   = 1.0
            }
        case .touchDown_ty:
            break
        case .disable_ty:
            self.isEnabled = false
            if self.type_ty == .theme_ty {
                self.backgroundColor = .gray
            } else {
                self.layer.opacity   = self.disableOpacity_ty
            }
        }
    }
    
    // MARK: ==== Event ====
    public func bindProperty_ty() {
        switch type_ty {
        case .normal_ty:
            self.setTitleColor(UIColor.black, for: .normal)
        case .theme_ty:
            self.setTitleColor(UIColor.white, for: .normal)
            self.layer.cornerRadius  = AdaptSize_ty(5)
            self.layer.masksToBounds = true
            self.backgroundColor     = UIColor.theme_ty
        case .second_ty:
            self.setTitleColor(UIColor.white, for: .normal)
            self.layer.cornerRadius  = AdaptSize_ty(5)
            self.layer.masksToBounds = true
            self.backgroundColor     = UIColor.white
            self.layer.borderColor   = UIColor.theme_ty.cgColor
            self.layer.borderWidth   = AdaptSize_ty(1)
            self.setTitleColor(UIColor.theme_ty, for: .normal)
        }
        self.addTarget(self, action: #selector(touchDown_ty(sender_ty:)), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp_ty(sender_ty:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp_ty(sender_ty:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(touchUp_ty(sender_ty:)), for: .touchCancel)
    }
    
    @objc private func touchDown_ty(sender_ty: UIButton) {
        self.isEnabled = true
        if self.type_ty != .normal_ty {
            self.layer.opacity = 0.7
        }
        guard self.isAnimation_ty else { return }
        let animation_ty = CAKeyframeAnimation(keyPath: "transform.scale")
        animation_ty.values        = [0.9]
        animation_ty.duration      = 0.1
        animation_ty.autoreverses  = false
        animation_ty.fillMode      = .forwards
        animation_ty.isRemovedOnCompletion = false
        sender_ty.layer.add(animation_ty, forKey: nil)
    }
    
    @objc private func touchUp_ty(sender_ty: UIButton) {
        if type_ty != .normal_ty {
            self.layer.opacity = 1.0
        }
        guard self.isAnimation_ty else { return }
        let animation_ty = CAKeyframeAnimation(keyPath: "transform.scale")
        animation_ty.values        = [1.1, 0.95, 1.0]
        animation_ty.duration      = 0.2
        animation_ty.autoreverses  = false
        animation_ty.fillMode      = .forwards
        animation_ty.isRemovedOnCompletion = false
        sender_ty.layer.add(animation_ty, forKey: nil)
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
