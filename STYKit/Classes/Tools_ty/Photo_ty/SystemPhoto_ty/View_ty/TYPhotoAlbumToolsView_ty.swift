//
//  TYPhotoAlbumToolsView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Foundation

public protocol TYPhotoAlbumToolsDelegate_ty: NSObjectProtocol {
    func clickShareAction_ty()
    func clickSaveAction_ty()
    func clickDeleteAction_ty()
}

class TYPhotoAlbumToolsView_ty: TYView_ty {

    weak var delegate_ty: TYPhotoAlbumToolsDelegate_ty?

    private var shareButton_ty: TYButton_ty = {
        let button = TYButton_ty()
        button.setTitle("分享", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(size: AdaptSize_ty(13))
        return button
    }()
    private var saveButton_ty: TYButton_ty = {
        let button = TYButton_ty()
        button.setTitle("保存", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(size: AdaptSize_ty(13))
        return button
    }()
    private var deleteButton_ty: TYButton_ty = {
        let button = TYButton_ty()
        button.setTitle("删除", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(size: AdaptSize_ty(13))
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews_ty() {
        super.createSubviews_ty()
        let itemSize = CGSize(width: AdaptSize_ty(50), height: 50)
        shareButton_ty.size_ty    = itemSize
        saveButton_ty.size_ty     = itemSize
        deleteButton_ty.size_ty   = itemSize
        let stackView_ty = UIStackView(arrangedSubviews: [shareButton_ty, saveButton_ty, deleteButton_ty])
        stackView_ty.alignment    = .center
        stackView_ty.axis         = .horizontal
        stackView_ty.distribution = .equalSpacing
        stackView_ty.spacing      = AdaptSize_ty(50)
        self.addSubview(stackView_ty)
        stackView_ty.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin_ty)
        }
    }

    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
}
