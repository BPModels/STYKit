//
//  TYNavigationBar_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation
import SnapKit

public protocol TYNavigationBarDelegate_ty: NSObjectProtocol {
    func leftAction_ty()
    func rightAction_ty()
}

open class TYNavigationBar_ty: TYView_ty {
    public var leftViewList_ty  = [UIView]()
    public var rightViewList_ty = [UIView]()
    public var delegate: TYNavigationBarDelegate_ty?
    
    private let buttonSize   = CGSize(width: AdaptSize_ty(53), height: AdaptSize_ty(27))
    private let leftOffsetX  = AdaptSize_ty(12)
    private let rightOffsetX = AdaptSize_ty(-12)
    
    public let titleLabel_ty: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text = ""
        label.font = UIFont.custom_ty(.PingFangTCRegular, size: AdaptSize_ty(18))
        return label
    }()
    
    public let leftButton_ty: TYButton_ty = {
        let button = TYButton_ty()
        button.setImage(UIImage.name_ty("back_ty", type: .pdf), for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    public lazy var rightButton_ty: TYButton_ty = {
        let button = TYButton_ty()
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.updateUI_ty()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(leftButton_ty)
        self.addSubview(titleLabel_ty)
        self.addSubview(rightButton_ty)
        leftButton_ty.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftOffsetX).priority(.low)
            make.centerY.equalTo(titleLabel_ty)
            make.width.equalTo(buttonSize.width)
            make.height.equalTo(buttonSize.height)
        }
        titleLabel_ty.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-10))
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(leftButton_ty.snp.right).offset(AdaptSize_ty(5))
            make.right.lessThanOrEqualTo(rightButton_ty.snp.left).offset(-AdaptSize_ty(5))
            make.height.equalTo(titleLabel_ty.font.lineHeight)
        }
        rightButton_ty.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(rightOffsetX).priority(.low)
            make.centerY.equalTo(titleLabel_ty)
            make.width.equalTo(buttonSize.width)
            make.height.equalTo(buttonSize.height)
        }
    }
    
    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.leftButton_ty.addTarget(self, action: #selector(clickLeftAction_ty(sender:)), for: .touchUpInside)
        self.rightButton_ty.addTarget(self, action: #selector(clickRightAction_ty(sender:)), for: .touchUpInside)
        // 设置默认标题
        self.title           = currentVC_ty?.title
        self.backgroundColor = .theme_ty
    }
    
    // MARK: ==== Event ====
    /// 设置左边文案
    /// - Parameter text: 文案
    public func setLeftTitle_ty(text: String?) {
        self.leftButton_ty.setTitle(text, for: .normal)
        let _newWidth = self.leftButton_ty.sizeThatFits(CGSize(width: kScreenWidth_ty, height: self.buttonSize.height)).width
        self.leftButton_ty.snp.updateConstraints { make in
            make.width.equalTo(_newWidth + AdaptSize_ty(10))
        }
    }
    
    /// 标题
    public var title: String? = "" {
        willSet {
            self.titleLabel_ty.text = newValue
        }
    }
    
    /// 设置左边文案
    /// - Parameter text: 文案
    public func setRightTitle_ty(text: String?) {
        self.rightButton_ty.setTitle(text, for: .normal)
        self.rightButton_ty.isHidden = false
        let _newWidth = self.rightButton_ty.sizeThatFits(CGSize(width: kScreenWidth_ty, height: self.buttonSize.height)).width
        self.rightButton_ty.snp.updateConstraints { make in
            make.width.equalTo(_newWidth + AdaptSize_ty(10))
        }
    }
    
    /// 点击左边按钮
    @objc private func clickLeftAction_ty(sender: TYButton_ty) {
        sender.status = .disable
        self.delegate?.leftAction_ty()
        sender.status = .normal
    }
    
    /// 点击右边按钮
    @objc private func clickRightAction_ty(sender: TYButton_ty) {
        sender.status = .disable
        self.delegate?.rightAction_ty()
        sender.status = .normal
    }
    
}
