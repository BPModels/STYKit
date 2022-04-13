//
//  TYBaseAlertView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

/// 优先级由高到低
public enum TYAlertPriorityEnum_ty: Int {
    case A = 0
    case B = 1
    case C = 2
    case D = 3
    case E = 4
    case F = 5
    case normal = 100
}

/// AlertView的基类,默认只显示标题或者标题+描述信息
open class TYBaseAlertView_ty: TYTopWindowView_ty {
    
    /// 弹框优先级
    public var priority_ty: TYAlertPriorityEnum_ty = .normal
    /// 是否已展示过
    public var isShowed_ty = false
    /// 默认事件触发后自动关闭页面
    public var autoClose_ty: Bool = true
    /// 确定按钮是否标红（破坏性操作警告）
    public var isDestruct_ty: Bool = false
    
    /// 弹框的默认宽度
    public var mainViewWidth_ty = AdaptSize_ty(275)
    /// 弹框的默认高度
    public var mainViewHeight_ty: CGFloat = .zero
    /// 弹框内容最大高度
    public var maxContentHeight_ty: CGFloat = AdaptSize_ty(300)
    
    /// 间距
    public let leftPadding_ty: CGFloat   = AdaptSize_ty(20)
    public let rightPadding_ty: CGFloat  = AdaptSize_ty(20)
    public let topPadding_ty: CGFloat    = AdaptSize_ty(20)
    public let bottomPadding_ty: CGFloat = AdaptSize_ty(25)
    public let defaultSpace_ty: CGFloat  = AdaptSize_ty(15)
    public let closeBtnSize_ty: CGSize   = CGSize(width: AdaptSize_ty(50), height: AdaptSize_ty(50))
    
    public let webCotentHeight_ty        = AdaptSize_ty(300)
    public let imageViewSize_ty: CGSize  = CGSize(width: AdaptSize_ty(300), height: AdaptSize_ty(500))
    
    // 标题的高度
    public var titleHeight_ty: CGFloat {
        get {
            return self.titleLabel_ty.textHeight_ty(width: mainViewWidth_ty - leftPadding_ty - rightPadding_ty)
        }
    }
    // 描述的高度
    public var descriptionHeight_ty: CGFloat {
        get {
            return self.descriptionLabel_ty.textHeight_ty(width: mainViewWidth_ty - leftPadding_ty - rightPadding_ty)
        }
    }
    
    public var descriptionText_ty: String = ""
    public var imageUrlStr_ty: String?
    public var leftActionBlock_ty: DefaultBlock_ty?
    public var rightActionBlock_ty: DefaultBlock_ty?
    public var closeActionBlock_ty: DefaultBlock_ty?
    public var imageActionBlock_ty: ((String?)->Void)?
    
    // 弹框的背景
    open var mainView_ty: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.white
        view.layer.cornerRadius  = AdaptSize_ty(15)
        view.layer.masksToBounds = true
        return view
    }()

    // 弹窗标题
    open var titleLabel_ty: UILabel = {
        let label           = UILabel()
        label.numberOfLines = 1
        label.textColor     = UIColor.black
        label.font          = UIFont.custom_ty(.PingFangTCSemibold, size: AdaptSize_ty(20))
        label.textAlignment = .center
        return label
    }()
    
    open var contentScrollView_ty: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator   = false
        return scrollView
    }()
    
    /// 自定义富文本视图
//    open var attributionView: KFAttributionView?

    // 弹窗描述
    open var descriptionLabel_ty: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black
        label.font          = UIFont.custom_ty(.PingFangTCRegular, size: AdaptSize_ty(15))
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    /// 背景图
    internal var backgroundImage_ty: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    /// 左边按钮
    open var leftButton_ty: TYButton_ty = {
        let button = TYButton_ty()
        button.size_ty = CGSize(width: AdaptSize_ty(100), height: AdaptSize_ty(35))
        button.backgroundColor = UIColor.gray0_ty
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font    = UIFont.custom_ty(.PingFangTCSemibold, size: AdaptSize_ty(14))
        button.layer.cornerRadius  = AdaptSize_ty(17.5)
        button.layer.masksToBounds = true
        return button
    }()

    /// 右边按钮
    open var rightButton_ty: TYButton_ty = {
        let button = TYButton_ty(.theme, animation: false)
        button.size_ty = CGSize(width: AdaptSize_ty(100), height: AdaptSize_ty(35))
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font    = UIFont.custom_ty(.PingFangTCSemibold, size: AdaptSize_ty(14))
        return button
    }()
    
    open override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(mainView_ty)
        self.mainView_ty.addSubview(backgroundImage_ty)
        backgroundImage_ty.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    open override func bindProperty_ty() {
        super.bindProperty_ty()
        self.leftButton_ty.addTarget(self, action: #selector(leftAction_ty), for: .touchUpInside)
        self.rightButton_ty.addTarget(self, action: #selector(rightAction_ty), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    open override func show_ty(view: UIView = kWindow_ty) {
        super.show_ty(view: view)
        currentVC_ty?.view.endEditing(true)
        // 果冻动画
        self.mainView_ty.layer.addJellyAnimation_ty()
    }

    @objc
    open func leftAction_ty() {
        self.leftActionBlock_ty?()
        if autoClose_ty {
            self.hide_ty()
        }
    }

    @objc
    open func rightAction_ty() {
        self.rightActionBlock_ty?()
        if autoClose_ty {
            self.hide_ty()
        }
    }
    
    @objc
    open override func hide_ty() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.mainView_ty.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        super.hide_ty()
        self.closeActionBlock_ty?()
    }
}
