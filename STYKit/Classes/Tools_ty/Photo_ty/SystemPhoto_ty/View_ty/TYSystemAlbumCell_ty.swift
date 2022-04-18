//
//  TYSystemAlbumCell_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import UIKit

class TYSystemAlbumCell_ty: UITableViewCell {

    private var nameLabel_ty: UILabel = {
        let label_ty = UILabel()
        label_ty.text          = ""
        label_ty.textColor     = UIColor.black
        label_ty.font          = UIFont.regular_ty(AdaptSize_ty(15))
        label_ty.textAlignment = .left
        return label_ty
    }()
    private var selectedImageView_ty: TYImageView_ty = {
        let imageView_ty = TYImageView_ty()
        imageView_ty.contentMode = .scaleAspectFill
        imageView_ty.image       = UIImage(named: "chat_photo_selected")
        return imageView_ty
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews_ty() {
        self.addSubview(nameLabel_ty)
        self.addSubview(selectedImageView_ty)

        nameLabel_ty.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.right.equalTo(selectedImageView_ty.snp.left).offset(AdaptSize_ty(-5))
            make.centerY.height.equalToSuperview()
        }
        selectedImageView_ty.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize_ty(16), height: AdaptSize_ty(16)))
            make.right.equalToSuperview().offset(AdaptSize_ty(-15))
        }
    }

    private func bindProperty_ty() {
        self.selectionStyle = .none
    }

    func setData_ty(model_ty: TYPhotoAlbumModel_ty, isCurrent_ty: Bool) {
        self.nameLabel_ty.text         = (model_ty.assetCollection_ty?.localizedTitle ?? "") + "(\(model_ty.assets_ty.count))"
        self.selectedImageView_ty.isHidden = !isCurrent_ty
    }
}
