//
//  TYActionSheet_ty.swift
//  Pods-STYKit_Example
//
//  Created by apple on 2022/4/11.
//

import SnapKit

public class TYActionSheet_ty: TYTopWindowView_ty {

    public let cellHeight_ty: CGFloat   = AdaptSize_ty(55)
    let lineHeight_ty: CGFloat          = 1/UIScreen.main.scale
    let spaceHeight_ty: CGFloat         = AdaptSize_ty(7)
    public var maxH_ty                  = CGFloat.zero
    var buttonList_ty: [TYButton_ty]    = []
    public var actionDict_ty: [String:DefaultBlock_ty] = [:]
    private var title_ty: String?

    /// 无裁切的底部视图的父视图
    public var contentView_ty: TYView_ty = {
        let view_ty = TYView_ty()
        view_ty.backgroundColor = UIColor.clear
        return view_ty
    }()
    
    /// 负责显示视图的底视图
    public var mainView_ty: UIView = {
        let view_ty = UIView()
        view_ty.backgroundColor    = UIColor.white
        view_ty.layer.cornerRadius = AdaptSize_ty(8)
        return view_ty
    }()
    
    public init(title_ty: String? = nil) {
        super.init(frame: .zero)
        self.title_ty = title_ty
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
    public func addItem_ty(icon_ty: UIImage? = nil, title_ty: String, isDestroy_ty: Bool = false, actionBlock_ty: DefaultBlock_ty?) -> TYActionSheet_ty {
        let button_ty = TYButton_ty(.normal_ty)
        button_ty.setTitle(title_ty, for: .normal)
        if isDestroy_ty {
            button_ty.setTitleColor(UIColor.red0_ty, for: .normal)
        } else {
            button_ty.setTitleColor(UIColor.black0_ty, for: .normal)
        }
        if let _icon_ty = icon_ty {
            button_ty.setImage(_icon_ty, for: .normal)
            button_ty.imageView?.size_ty = CGSize(width: AdaptSize_ty(20), height: AdaptSize_ty(20))
        }
        button_ty.titleLabel?.font = UIFont.semibold_ty(AdaptSize_ty(15))
        button_ty.addTarget(self, action: #selector(clickAction_ty(sender_ty:)), for: .touchUpInside)
        mainView_ty.addSubview(button_ty)
        button_ty.snp.makeConstraints { (make_ty) in
            make_ty.left.right.equalToSuperview()
            make_ty.top.equalToSuperview().offset(maxH_ty)
            make_ty.height.equalTo(cellHeight_ty)
        }
        maxH_ty += cellHeight_ty
        self.buttonList_ty.append(button_ty)
        if actionBlock_ty != nil {
            self.actionDict_ty[title_ty] = actionBlock_ty
        }
        return self
    }
    
    /// 添加标题
    private func addTitle_ty() {
        guard let _title_ty = self.title_ty else { return }
        let label_ty = TYLabel_ty()
        label_ty.text          = _title_ty
        label_ty.textColor     = UIColor.gray0_ty
        label_ty.font          = UIFont.medium_ty(AdaptSize_ty(14))
        label_ty.textAlignment = .center
        mainView_ty.addSubview(label_ty)
        label_ty.snp.makeConstraints { (make_ty) in
            make_ty.left.right.equalToSuperview()
            make_ty.top.equalToSuperview().offset(maxH_ty)
            make_ty.height.equalTo(cellHeight_ty)
        }
        maxH_ty += cellHeight_ty
    }

    /// 添加默认的底部间距和取消按钮
    private func addDefaultItem_ty() {
        let spaceView_ty = UIView()
        spaceView_ty.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        mainView_ty.addSubview(spaceView_ty)
        spaceView_ty.snp.makeConstraints { (make_ty) in
            make_ty.left.right.equalToSuperview()
            make_ty.top.equalToSuperview().offset(maxH_ty)
            make_ty.height.equalTo(spaceHeight_ty)
        }
        maxH_ty += spaceHeight_ty

        let cancelButton_ty = TYButton_ty()
        cancelButton_ty.setTitle("取消", for: .normal)
        cancelButton_ty.titleLabel?.font = UIFont.semibold_ty(AdaptSize_ty(15))
        cancelButton_ty.setTitleColor(UIColor.black0_ty, for: .normal)
        cancelButton_ty.addTarget(self, action: #selector(self.hide_ty), for: .touchUpInside)
        mainView_ty.addSubview(cancelButton_ty)
        cancelButton_ty.snp.makeConstraints { (make_ty) in
            make_ty.left.right.equalToSuperview()
            make_ty.top.equalTo(spaceView_ty.snp.bottom)
            make_ty.height.equalTo(cellHeight_ty)
        }
        maxH_ty += cellHeight_ty + kSafeBottomMargin_ty
        self.buttonList_ty.append(cancelButton_ty)
    }

    private func adjustMainView_ty() {
        mainView_ty.size_ty = CGSize(width: kScreenWidth_ty, height: maxH_ty)
        mainView_ty.clipRectCorner_ty(directionList_ty: [.topLeft, .topRight], cornerRadius_ty: AdaptSize_ty(15))
        mainView_ty.snp.makeConstraints { (make_ty) in
            make_ty.edges.equalToSuperview()
        }
        contentView_ty.snp.makeConstraints { make_ty in
            make_ty.left.right.equalToSuperview()
            make_ty.height.equalTo(maxH_ty)
            make_ty.top.equalTo(self.snp.bottom)
        }
    }
    
    @objc public func clickAction_ty(sender_ty: TYButton_ty) {
        guard let title_ty = sender_ty.currentTitle else {
            print("暂无事件")
            return
        }
        self.actionDict_ty[title_ty]?()
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

    public override func show_ty(view_ty: UIView = kWindow_ty) {
        super.show_ty(view_ty: view_ty)
        self.addDefaultItem_ty()
        self.adjustMainView_ty()
        TYRecordAudioManager_ty.share_ty.shake_ty()
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.contentView_ty.transform = CGAffineTransform(translationX: 0, y: -self.maxH_ty)
        }
    }
}
