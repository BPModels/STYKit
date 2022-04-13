//
//  TYActionSheet_ty.swift
//  Pods-STYKit_Example
//
//  Created by apple on 2022/4/11.
//

import SnapKit

open class TYActionSheet_ty: TYTopWindowView_ty {

    public let cellHeight_ty: CGFloat  = AdaptSize_ty(55)
    let lineHeight_ty: CGFloat  = 1/UIScreen.main.scale
    let spaceHeight_ty: CGFloat = AdaptSize_ty(7)
    public var maxH_ty = CGFloat.zero
    var buttonList_ty: [TYButton_ty] = []
    public var actionDict_ty: [String:DefaultBlock_ty] = [:]
    private var title_ty: String?

    /// 无裁切的底部视图的父视图
    public var contentView_ty: TYView_ty = {
        let view = TYView_ty()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    /// 负责显示视图的底视图
    public var mainView_ty: UIView = {
        let view = UIView()
        view.backgroundColor    = UIColor.white
        view.layer.cornerRadius = AdaptSize_ty(8)
        return view
    }()
    
    public init(title: String? = nil) {
        super.init(frame: .zero)
        self.title_ty = title
        self.createSubviews_ty()
        self.bindProperty_ty()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(contentView_ty)
        contentView_ty.addSubview(mainView_ty)
        self.addTitle_ty()
    }

    public override func bindProperty_ty() {
        super.bindProperty_ty()
    }

    // MARK: ==== Event ====
    @discardableResult @objc
    public func addItem_ty(icon: UIImage? = nil, title: String, isDestroy: Bool = false, actionBlock: DefaultBlock_ty?) -> TYActionSheet_ty {
        let button = TYButton_ty(.normal)
        button.setTitle(title, for: .normal)
        if isDestroy {
            button.setTitleColor(UIColor.red0_ty, for: .normal)
        } else {
            button.setTitleColor(UIColor.black0_ty, for: .normal)
        }
        if let _icon = icon {
            button.setImage(_icon, for: .normal)
            button.imageView?.size_ty = CGSize(width: AdaptSize_ty(20), height: AdaptSize_ty(20))
        }
        button.titleLabel?.font = UIFont.custom_ty(.PingFangTCSemibold, size: AdaptSize_ty(15))
        button.addTarget(self, action: #selector(clickAction_ty(sender:)), for: .touchUpInside)
        mainView_ty.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(maxH_ty)
            make.height.equalTo(cellHeight_ty)
        }
        maxH_ty += cellHeight_ty
        self.buttonList_ty.append(button)
        if actionBlock != nil {
            self.actionDict_ty[title] = actionBlock
        }
        return self
    }
    
    /// 添加标题
    private func addTitle_ty() {
        guard let _title = self.title_ty else { return }
        let label = TYLabel_ty()
        label.text          = _title
        label.textColor     = UIColor.gray0_ty
        label.font          = UIFont.custom_ty(.PingFangTCMedium, size: AdaptSize_ty(14))
        label.textAlignment = .center
        mainView_ty.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(maxH_ty)
            make.height.equalTo(cellHeight_ty)
        }
        maxH_ty += cellHeight_ty
    }

    /// 添加默认的底部间距和取消按钮
    private func addDefaultItem_ty() {
        let spaceView = UIView()
        spaceView.backgroundColor = .gray0_ty
        mainView_ty.addSubview(spaceView)
        spaceView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(maxH_ty)
            make.height.equalTo(spaceHeight_ty)
        }
        maxH_ty += spaceHeight_ty

        let cancelButton = TYButton_ty()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = UIFont.custom_ty(.PingFangTCSemibold, size: AdaptSize_ty(15))
        cancelButton.setTitleColor(UIColor.black0_ty, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.hide_ty), for: .touchUpInside)
        mainView_ty.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(spaceView.snp.bottom)
            make.height.equalTo(cellHeight_ty)
        }
        maxH_ty += cellHeight_ty + kSafeBottomMargin_ty
        self.buttonList_ty.append(cancelButton)
    }

    private func adjustMainView_ty() {
        mainView_ty.size_ty = CGSize(width: kScreenWidth_ty, height: maxH_ty)
        mainView_ty.clipRectCorner_ty(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize_ty(15))
        mainView_ty.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView_ty.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(maxH_ty)
            make.top.equalTo(self.snp.bottom)
        }
    }
    
    @objc public func clickAction_ty(sender: TYButton_ty) {
        guard let title = sender.currentTitle else {
            print("暂无事件")
            return
        }
        self.actionDict_ty[title]?()
        // 默认点击后收起ActionSheet
        self.hide_ty()
    }

    @objc
    public override func hide_ty() {
        super.hide_ty()
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.contentView_ty.transform = .identity
        } completion: { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
                self.removeFromSuperview()
            }
        }
    }

    public override func show_ty(view: UIView = kWindow_ty) {
        super.show_ty(view: view)
        self.addDefaultItem_ty()
        self.adjustMainView_ty()
        TYRecordAudioManager_ty.share_ty.shake_ty()
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.contentView_ty.transform = CGAffineTransform(translationX: 0, y: -self.maxH_ty)
        }
    }
}
