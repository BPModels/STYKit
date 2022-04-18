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

public class TYPhotoAlbumToolsView_ty: TYView_ty {

    weak var delegate_ty: TYPhotoAlbumToolsDelegate_ty?

    private var shareButton_ty: TYButton_ty = {
        let button_ty = TYButton_ty()
        button_ty.setTitle("分享", for: .normal)
        button_ty.setTitleColor(UIColor.white, for: .normal)
        button_ty.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(13))
        return button_ty
    }()
    private var saveButton_ty: TYButton_ty = {
        let button_ty = TYButton_ty()
        button_ty.setTitle("保存", for: .normal)
        button_ty.setTitleColor(UIColor.white, for: .normal)
        button_ty.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(13))
        return button_ty
    }()
    private var deleteButton_ty: TYButton_ty = {
        let button_ty = TYButton_ty()
        button_ty.setTitle("删除", for: .normal)
        button_ty.setTitleColor(UIColor.white, for: .normal)
        button_ty.titleLabel?.font = UIFont.regular_ty(AdaptSize_ty(13))
        return button_ty
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func createSubviews_ty() {
        super.createSubviews_ty()
        let itemSize_ty = CGSize(width: AdaptSize_ty(50), height: 50)
        shareButton_ty.size_ty    = itemSize_ty
        saveButton_ty.size_ty     = itemSize_ty
        deleteButton_ty.size_ty   = itemSize_ty
        let stackView_ty = UIStackView(arrangedSubviews: [shareButton_ty, saveButton_ty, deleteButton_ty])
        stackView_ty.alignment    = .center
        stackView_ty.axis         = .horizontal
        stackView_ty.distribution = .equalSpacing
        stackView_ty.spacing      = AdaptSize_ty(50)
        self.addSubview(stackView_ty)
        stackView_ty.snp.makeConstraints { (make_ty) in
            make_ty.top.centerX.equalToSuperview()
            make_ty.bottom.equalToSuperview().offset(-kSafeBottomMargin_ty)
        }
    }

    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
}
