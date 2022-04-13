//
//  TYTopWindowView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

open class TYTopWindowView_ty: TYView_ty {
    
    /// 全屏透明背景
    open var backgroundView_ty: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.opacity   = .zero
        view.isUserInteractionEnabled = true
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        self.registerNotification_ty()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(backgroundView_ty)
        backgroundView_ty.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    open override func bindProperty_ty() {
        super.bindProperty_ty()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide_ty))
        self.backgroundView_ty.addGestureRecognizer(tap)
    }
    
    open override func registerNotification_ty() {
        super.registerNotification_ty()
    }

    // MARK: ==== Event ===
    /// 显示弹框
    open func show_ty(view: UIView = kWindow_ty) {
        view.addSubview(self)
        self.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.backgroundView_ty.layer.opacity = 1.0
        }
    }

    /// 子类自己实现
    @objc
    open func hide_ty() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.backgroundView_ty.layer.opacity = 0.0
        } completion: { [weak self] (finished) in
            if finished {
                self?.removeFromSuperview()
            }
        }
    }
}
