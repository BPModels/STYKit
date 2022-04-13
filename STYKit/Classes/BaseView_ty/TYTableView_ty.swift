//
//  TYTableView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

open class TYTableView_ty: UITableView {
    
    /// 是否隐藏默认为空页面
    public var isHideEmpTYView_ty = false
    public var emptyImage_ty: UIImage?
    public var emptyHintText_ty: String?
    
    open override func reloadData() {
        super.reloadData()
        self.configEmpTYView_ty()
    }
    
    private func configEmpTYView_ty() {
        var rows     = 0
        let sections = numberOfSections
        for section in 0..<sections {
            rows += numberOfRows(inSection: section)
        }
        if (rows == 0 && sections == 0) || (rows == 0 && sections == 1 && headerView(forSection: 0) == nil && footerView(forSection: 0) == nil) {
            // 显示默认页面
            if !self.isHideEmpTYView_ty {
                let empTYView_ty = TYTableView_tyEmpTYView_ty()
                empTYView_ty.setData(image: emptyImage_ty, hintText: emptyHintText_ty)
                self.backgroundView = empTYView_ty
            }
        } else {
            // 隐藏默认页面
            self.backgroundColor = nil
        }
    }
}

/// TableView 的空页面
class TYTableView_tyEmpTYView_ty: TYView_ty {
    
    private var contentView_ty: TYView_ty = {
        let view = TYView_ty()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private var imageView_ty: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode     = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private var hintLabel_ty: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black
        label.font          = UIFont.custom_ty(.PingFangTCSemibold, size: AdaptSize_ty(16))
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== KFViewDelegate ====
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(contentView_ty)
        contentView_ty.addSubview(imageView_ty)
        contentView_ty.addSubview(hintLabel_ty)
        contentView_ty.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        imageView_ty.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize_ty(84), height: AdaptSize_ty(84)))
        }
        hintLabel_ty.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.top.equalTo(imageView_ty.snp.bottom).offset(AdaptSize_ty(10))
            make.height.equalTo(hintLabel_ty.font.lineHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.backgroundColor = .clear
    }
    
    // MARK: ==== Event ====
    func setData(image: UIImage?, hintText: String?) {
        if let _image = image {
            self.imageView_ty.isHidden = false
            self.imageView_ty.image    = _image
        } else {
            // 默认图
            self.imageView_ty.isHidden = true
        }
        if let _hintText = hintText {
            self.hintLabel_ty.text = _hintText
        } else {
            // 默认文案
            self.hintLabel_ty.text = "暂无数据"
        }
    }
}
