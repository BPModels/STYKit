//
//  TYEmptyView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import Foundation

/// TableView 的空页面
class TYEmptyView_ty: TYView_ty {
    
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
        label.font          = UIFont.semibold_ty(size: AdaptSize_ty(16))
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
    func setData_ty(image: UIImage?, hintText: String?) {
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
