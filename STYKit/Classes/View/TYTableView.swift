//
//  TYTableView.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

open class TYTableView: UITableView {
    
    /// 是否隐藏默认为空页面
    public var isHideEmpty = false
    public var emptyImage: UIImage?
    public var emptyHintText: String?
    
    open override func reloadData() {
        super.reloadData()
        self.configEmptyView_ty()
    }
    
    private func configEmptyView_ty() {
        var rows     = 0
        let sections = numberOfSections
        for section in 0..<sections {
            rows += numberOfRows(inSection: section)
        }
        if (rows == 0 && sections == 0) || (rows == 0 && sections == 1 && headerView(forSection: 0) == nil && footerView(forSection: 0) == nil) {
            // 显示默认页面
            if !self.isHideEmpty {
                let emptyView = TYTableViewEmptyView()
                emptyView.setData(image: emptyImage, hintText: emptyHintText)
                self.backgroundView = emptyView
            }
        } else {
            // 隐藏默认页面
            self.backgroundColor = nil
        }
    }
}

/// TableView 的空页面
class TYTableViewEmptyView: TYView {
    
    private var contentView: TYView = {
        let view = TYView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode     = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private var hintLabel: TYLabel = {
        let label = TYLabel()
        label.text          = ""
        label.textColor     = UIColor.black
        label.font          = UIFont.custom(.PingFangTCSemibold, size: AdaptSize_ty(16))
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
        self.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(hintLabel)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize_ty(84), height: AdaptSize_ty(84)))
        }
        hintLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
            make.top.equalTo(imageView.snp.bottom).offset(AdaptSize_ty(10))
            make.height.equalTo(hintLabel.font.lineHeight)
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
            self.imageView.isHidden = false
            self.imageView.image    = _image
        } else {
            // 默认图
            self.imageView.isHidden = true
        }
        if let _hintText = hintText {
            self.hintLabel.text = _hintText
        } else {
            // 默认文案
            self.hintLabel.text = "暂无数据"
        }
    }
}
