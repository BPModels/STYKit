//
//  TYBaseAlertView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

/// 优先级由高到低
public enum TYAlertPriorityEnum_ty: Int {
    case A_ty = 0
    case B_ty = 1
    case C_ty = 2
    case D_ty = 3
    case E_ty = 4
    case F_ty = 5
    case normal_ty = 100
}

/// AlertView的基类,默认只显示标题或者标题+描述信息
open class TYBaseAlertView_ty: TYTopWindowView_ty {
    
    /// 弹框优先级
    public var priority_ty: TYAlertPriorityEnum_ty = .normal_ty
    /// 是否已展示过
    public var isShowed_ty         = false
    /// 默认事件触发后自动关闭页面
    public var autoClose_ty: Bool  = true
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
            return self.titleLabel_ty.textHeight_ty(width_ty: mainViewWidth_ty - leftPadding_ty - rightPadding_ty)
        }
    }
    // 描述的高度
    public var descriptionHeight_ty: CGFloat {
        get {
            return self.descriptionLabel_ty.textHeight_ty(width_ty: mainViewWidth_ty - leftPadding_ty - rightPadding_ty)
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
        let view_ty = UIView()
        view_ty.backgroundColor     = UIColor.white
        view_ty.layer.cornerRadius  = AdaptSize_ty(15)
        view_ty.layer.masksToBounds = true
        return view_ty
    }()

    // 弹窗标题
    open var titleLabel_ty: UILabel = {
        let label_ty           = UILabel()
        label_ty.numberOfLines = 1
        label_ty.textColor     = UIColor.black
        label_ty.font          = UIFont.semibold_ty(AdaptSize_ty(20))
        label_ty.textAlignment = .center
        return label_ty
    }()
    
    open var contentScrollView_ty: UIScrollView = {
       let scrollView_ty = UIScrollView()
        scrollView_ty.showsHorizontalScrollIndicator = false
        scrollView_ty.showsVerticalScrollIndicator   = false
        return scrollView_ty
    }()
    
    /// 自定义富文本视图
//    open var attributionView: KFAttributionView?

    // 弹窗描述
    open var descriptionLabel_ty: UILabel = {
        let label_ty = UILabel()
        label_ty.textColor     = UIColor.black
        label_ty.font          = UIFont.regular_ty(AdaptSize_ty(15))
        label_ty.numberOfLines = 0
        label_ty.textAlignment = .center
        return label_ty
    }()
    
    /// 背景图
    internal var backgroundImage_ty: TYImageView_ty = {
        let imageView_ty = TYImageView_ty()
        imageView_ty.contentMode = .scaleToFill
        return imageView_ty
    }()
    
    /// 左边按钮
    open var leftButton_ty: TYButton_ty = {
        let button_ty = TYButton_ty()
        button_ty.size_ty = CGSize(width: AdaptSize_ty(100), height: AdaptSize_ty(35))
        button_ty.backgroundColor = UIColor.gray0_ty
        button_ty.setTitleColor(UIColor.black, for: .normal)
        button_ty.titleLabel?.font    = UIFont.semibold_ty(AdaptSize_ty(14))
        button_ty.layer.cornerRadius  = AdaptSize_ty(17.5)
        button_ty.layer.masksToBounds = true
        return button_ty
    }()

    /// 右边按钮
    open var rightButton_ty: TYButton_ty = {
        let button_ty = TYButton_ty(.theme_ty, animation_ty: false)
        button_ty.size_ty = CGSize(width: AdaptSize_ty(100), height: AdaptSize_ty(35))
        button_ty.setTitleColor(UIColor.white, for: .normal)
        button_ty.titleLabel?.font = UIFont.semibold_ty(AdaptSize_ty(14))
        return button_ty
    }()
    
    open override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(mainView_ty)
        self.mainView_ty.addSubview(backgroundImage_ty)
        backgroundImage_ty.snp.makeConstraints { make_ty in
            make_ty.edges.equalToSuperview()
        }
    }
    
    open override func bindProperty_ty() {
        super.bindProperty_ty()
        self.leftButton_ty.addTarget(self, action: #selector(leftAction_ty), for: .touchUpInside)
        self.rightButton_ty.addTarget(self, action: #selector(rightAction_ty), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    open override func show_ty(view_ty: UIView = kWindow_ty) {
        super.show_ty(view_ty: view_ty)
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
