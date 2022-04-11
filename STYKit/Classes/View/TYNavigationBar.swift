//
//  TYNavigationBar.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation
import SnapKit

public protocol TYNavigationBarDelegate: NSObjectProtocol {
    func leftAction_ty()
    func rightAction_ty()
}

open class TYNavigationBar: TYView {
    public var leftViewList_ty  = [UIView]()
    public var rightViewList_ty = [UIView]()
    public var delegate: TYNavigationBarDelegate?
    
    private let buttonSize   = CGSize(width: AdaptSize_ty(53), height: AdaptSize_ty(27))
    private let leftOffsetX  = AdaptSize_ty(12)
    private let rightOffsetX = AdaptSize_ty(-12)
    
    public let titleLabel: TYLabel = {
        let label = TYLabel()
        label.text = ""
        label.font = UIFont.custom(.PingFangTCRegular, size: AdaptSize_ty(18))
        return label
    }()
    
    public let leftButton: TYButton = {
        let button = TYButton()
        button.setImage(UIImage.name("back_ty", type: .pdf), for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    public lazy var rightButton: TYButton = {
        let button = TYButton()
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
        self.addSubview(leftButton)
        self.addSubview(titleLabel)
        self.addSubview(rightButton)
        leftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftOffsetX).priority(.low)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(buttonSize.width)
            make.height.equalTo(buttonSize.height)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-10))
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(leftButton.snp.right).offset(AdaptSize_ty(5))
            make.right.lessThanOrEqualTo(rightButton.snp.left).offset(-AdaptSize_ty(5))
            make.height.equalTo(titleLabel.font.lineHeight)
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(rightOffsetX).priority(.low)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(buttonSize.width)
            make.height.equalTo(buttonSize.height)
        }
    }
    
    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.leftButton.addTarget(self, action: #selector(clickLeftAction(sender:)), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(clickRightAction(sender:)), for: .touchUpInside)
        // 设置默认标题
        self.title           = currentVC?.title
        self.backgroundColor = .theme
    }
    
    // MARK: ==== Event ====
    /// 设置左边文案
    /// - Parameter text: 文案
    public func setLeftTitle(text: String?) {
        self.leftButton.setTitle(text, for: .normal)
        let _newWidth = self.leftButton.sizeThatFits(CGSize(width: kScreenWidth_ty, height: self.buttonSize.height)).width
        self.leftButton.snp.updateConstraints { make in
            make.width.equalTo(_newWidth + AdaptSize_ty(10))
        }
    }
    
    /// 标题
    public var title: String? = "" {
        willSet {
            self.titleLabel.text = newValue
        }
    }
    
    /// 设置左边文案
    /// - Parameter text: 文案
    public func setRightTitle(text: String?) {
        self.rightButton.setTitle(text, for: .normal)
        self.rightButton.isHidden = false
        let _newWidth = self.rightButton.sizeThatFits(CGSize(width: kScreenWidth_ty, height: self.buttonSize.height)).width
        self.rightButton.snp.updateConstraints { make in
            make.width.equalTo(_newWidth + AdaptSize_ty(10))
        }
    }
    
    /// 点击左边按钮
    @objc private func clickLeftAction(sender: TYButton) {
        sender.status = .disable
        self.delegate?.leftAction_ty()
        sender.status = .normal
    }
    
    /// 点击右边按钮
    @objc private func clickRightAction(sender: TYButton) {
        sender.status = .disable
        self.delegate?.rightAction_ty()
        sender.status = .normal
    }
    
}
