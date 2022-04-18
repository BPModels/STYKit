//
//  TYEmptyView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import Foundation

/// TableView 的空页面
open class TYEmptyView_ty: TYView_ty {
    
    private var contentView_ty: TYView_ty = {
        let view_ty = TYView_ty()
        view_ty.backgroundColor = UIColor.clear
        return view_ty
    }()
    
    private var imageView_ty: UIImageView = {
        let imageView_ty = UIImageView()
        imageView_ty.contentMode     = .scaleAspectFill
        imageView_ty.backgroundColor = .clear
        return imageView_ty
    }()
    
    private var hintLabel_ty: TYLabel_ty = {
        let label_ty = TYLabel_ty()
        label_ty.text          = ""
        label_ty.textColor     = UIColor.black
        label_ty.font          = UIFont.semibold_ty(AdaptSize_ty(16))
        label_ty.textAlignment = .center
        return label_ty
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    public init(image: UIImage?, hintText_ty: String?) {
        super.init(frame: .zero)
        if let _image_ty = image {
            self.imageView_ty.isHidden = false
            self.imageView_ty.image    = _image_ty
        } else {
            // 默认图
            self.imageView_ty.isHidden = true
        }
        if let _hintText_ty = hintText_ty {
            self.hintLabel_ty.text = _hintText_ty
        } else {
            // 默认文案
            self.hintLabel_ty.text = "暂无数据"
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== KFViewDelegate ====
    
    open override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(contentView_ty)
        contentView_ty.addSubview(imageView_ty)
        contentView_ty.addSubview(hintLabel_ty)
        contentView_ty.snp.makeConstraints { make_ty in
            make_ty.center.equalToSuperview()
        }
        imageView_ty.snp.makeConstraints { make_ty in
            make_ty.centerX.equalToSuperview()
            make_ty.top.equalToSuperview()
            make_ty.size.equalTo(CGSize(width: AdaptSize_ty(84), height: AdaptSize_ty(84)))
        }
        hintLabel_ty.snp.makeConstraints { make_ty in
            make_ty.left.equalToSuperview().offset(AdaptSize_ty(15))
            make_ty.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make_ty.top.equalTo(imageView_ty.snp.bottom).offset(AdaptSize_ty(10))
            make_ty.height.equalTo(hintLabel_ty.font.lineHeight)
            make_ty.bottom.equalToSuperview()
        }
    }
    
    open override func bindProperty_ty() {
        super.bindProperty_ty()
        self.backgroundColor = .clear
    }
}
