//
//  TYSystemAlbumCell.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import UIKit

class TYSystemAlbumCell: UITableViewCell {

    private var nameLabel_ty: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black
        label.font          = UIFont.custom_ty(.PingFangTCRegular, size: AdaptSize_ty(15))
        label.textAlignment = .left
        return label
    }()
    private var selectedImageView_ty: TYImageView = {
        let imageView = TYImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image       = UIImage(named: "chat_photo_selected")
        return imageView
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

    func setData_ty(model: TYPhotoAlbumModel, isCurrent: Bool) {
        self.nameLabel_ty.text         = (model.assetCollection_ty?.localizedTitle ?? "") + "(\(model.assets_ty.count))"
        self.selectedImageView_ty.isHidden = !isCurrent
    }
}
