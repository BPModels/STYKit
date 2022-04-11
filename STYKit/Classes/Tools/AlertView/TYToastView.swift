//
//  TYToastView.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

class TYToastView: TYView {
    
    private let maxWidth_ty     = AdaptSize_ty(230)
    private let defaultWidth_ty = AdaptSize_ty(120)
    private let defaultHight_ty = AdaptSize_ty(70)
    
    private var iconImageView: TYImageView = {
        let imageView = TYImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var descriptionLabel: TYLabel = {
        let label = TYLabel()
        label.text          = ""
        label.textColor     = UIColor.gray0
        label.font          = UIFont.custom_ty(.PingFangTCMedium, size: AdaptSize_ty(14))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        let _size = CGSize(width: defaultWidth_ty, height: defaultHight_ty)
        super.init(frame: CGRect(origin: CGPoint(x: (kScreenWidth_ty - _size.width)/2, y: (kScreenHeight_ty - _size.height)/2), size: _size))
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(iconImageView)
        self.addSubview(descriptionLabel)
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(20), height: AdaptSize_ty(20)))
            make.top.equalToSuperview().offset(AdaptSize_ty(13))
            make.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(AdaptSize_ty(7))
            make.left.equalToSuperview().offset(AdaptSize_ty(5))
            make.right.equalToSuperview().offset(AdaptSize_ty(-5))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-15))
        }
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.backgroundColor = .white
        self.layer.setDefaultShadow_ty(alpha: 0.6)
    }
    
    // MARK: ==== Event ====
    
    /// 显示成功提示
    /// - Parameter text: 提示内容
    func showSuccess(text: String) {
        self.descriptionLabel.text = text
        self.iconImageView.image   = UIImage(named: "reset_success_icon")
        self.updateSize()
    }
    
    /// 显示错误提示
    /// - Parameter text: 提示内容
    func showFail(text: String) {
        self.descriptionLabel.text = text
        self.iconImageView.image   = UIImage(named: "common_icon_error")
        self.updateSize()
    }
    
    func showWarn(text: String) {
        self.descriptionLabel.text = text
        self.iconImageView.image   = UIImage(named: "common_icon_warning")
        self.updateSize()
    }
    
    // MARK: ==== Tools ====
    private func updateSize() {
        self.descriptionLabel.sizeToFit()
        var _width = self.descriptionLabel.width_ty + AdaptSize_ty(10)
        if _width > self.maxWidth_ty {
            _width = self.maxWidth_ty
        } else if _width < self.defaultWidth_ty {
            _width = self.defaultWidth_ty
        }
        let _size = self.descriptionLabel.sizeThatFits(CGSize(width: _width, height: CGFloat(Int.max)))
        self.size_ty = CGSize(width: _size.width + AdaptSize_ty(10), height: _size.height + AdaptSize_ty(55))
        self.left_ty = (kScreenWidth_ty - self.width_ty)/2
    }
}

