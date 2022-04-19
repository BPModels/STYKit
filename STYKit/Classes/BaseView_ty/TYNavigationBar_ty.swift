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

public class TYNavigationBar_ty: TYView_ty {
    public var leftViewList_ty  = [UIView]()
    public var rightViewList_ty = [UIView]()
    public var delegate_ty: TYNavigationBarDelegate_ty?
    
    private let buttonSize_ty = CGSize(width: AdaptSize_ty(53), height: AdaptSize_ty(27))
    private let leftOffsetX  = AdaptSize_ty(12)
    private let rightOffsetX = AdaptSize_ty(-12)
    
    public let titleLabel_ty: TYLabel_ty = {
        let label_ty = TYLabel_ty()
        label_ty.text      = ""
        label_ty.textColor = UIColor.black0_ty
        label_ty.font      = UIFont.regular_ty(AdaptSize_ty(18))
        return label_ty
    }()
    
    public let leftButton_ty: TYButton_ty = {
        let button_ty = TYButton_ty()
        button_ty.setImage(UIImage(name_ty: "back_ty", type_ty: .png_ty), for: .normal)
        button_ty.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(16))
        button_ty.contentHorizontalAlignment = .left
        button_ty.imageEdgeInsets = UIEdgeInsets(top: 0, left: AdaptSize_ty(5), bottom: 0, right: AdaptSize_ty(30))
        button_ty.imageView?.contentMode = .scaleAspectFit
        return button_ty
    }()
    
    public lazy var rightButton_ty: TYButton_ty = {
        let button_ty = TYButton_ty()
        button_ty.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(16))
        button_ty.contentHorizontalAlignment = .center
        return button_ty
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
        leftButton_ty.snp.makeConstraints { (make_ty) in
            make_ty.left.equalToSuperview().offset(leftOffsetX).priority(.low)
            make_ty.centerY.equalTo(titleLabel_ty)
            make_ty.width.equalTo(buttonSize_ty.width)
            make_ty.height.equalTo(buttonSize_ty.height)
        }
        titleLabel_ty.snp.makeConstraints { (make_ty) in
            make_ty.bottom.equalToSuperview().offset(AdaptSize_ty(-10))
            make_ty.centerX.equalToSuperview()
            make_ty.left.greaterThanOrEqualTo(leftButton_ty.snp.right).offset(AdaptSize_ty(5))
            make_ty.right.lessThanOrEqualTo(rightButton_ty.snp.left).offset(-AdaptSize_ty(5))
            make_ty.height.equalTo(titleLabel_ty.font.lineHeight)
        }
        rightButton_ty.snp.makeConstraints { (make_ty) in
            make_ty.right.equalToSuperview().offset(rightOffsetX).priority(.low)
            make_ty.centerY.equalTo(titleLabel_ty)
            make_ty.width.equalTo(buttonSize_ty.width)
            make_ty.height.equalTo(buttonSize_ty.height)
        }
    }
    
    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.leftButton_ty.addTarget(self, action: #selector(clickLeftAction_ty(sender_ty:)), for: .touchUpInside)
        self.rightButton_ty.addTarget(self, action: #selector(clickRightAction_ty(sender_ty:)), for: .touchUpInside)
        // 设置默认标题
        self.title_ty        = currentVC_ty?.title
        self.backgroundColor = .white
    }
    
    // MARK: ==== Event ====
    /// 设置左边文案
    /// - Parameter text: 文案
    public func setLeftTitle_ty(text_ty: String?) {
        self.leftButton_ty.setTitle(text_ty, for: .normal)
        let _newWidth_ty = self.leftButton_ty.sizeThatFits(CGSize(width: kScreenWidth_ty, height: self.buttonSize_ty.height)).width
        self.leftButton_ty.snp.updateConstraints { make_ty in
            make_ty.width.equalTo(_newWidth_ty + AdaptSize_ty(10))
        }
    }
    
    /// 标题
    public var title_ty: String? = "" {
        willSet {
            self.titleLabel_ty.text = newValue
        }
    }
    
    /// 设置左边文案
    /// - Parameter text: 文案
    public func setRightTitle_ty(text_ty: String?) {
        self.rightButton_ty.setTitle(text_ty, for: .normal)
        self.rightButton_ty.isHidden = false
        let _newWidth_ty = self.rightButton_ty.sizeThatFits(CGSize(width: kScreenWidth_ty, height: self.buttonSize_ty.height)).width
        self.rightButton_ty.snp.updateConstraints { make_ty in
            make_ty.width.equalTo(_newWidth_ty + AdaptSize_ty(10))
        }
    }
    
    /// 点击左边按钮
    @objc private func clickLeftAction_ty(sender_ty: TYButton_ty) {
        sender_ty.status_ty = .disable_ty
        self.delegate_ty?.leftAction_ty()
        sender_ty.status_ty = .normal_ty
    }
    
    /// 点击右边按钮
    @objc private func clickRightAction_ty(sender_ty: TYButton_ty) {
        sender_ty.status_ty = .disable_ty
        self.delegate_ty?.rightAction_ty()
        sender_ty.status_ty = .normal_ty
    }
    
}
