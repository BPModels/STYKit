//
//  TYMediaCell_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Photos
import UIKit

public protocol TYPhotoAlbumCellDelegate_ty: NSObjectProtocol {
    func selectedImage_ty(model_ty: Any)
    func unselectImage_ty(model_ty: Any)
    /// 超额选择
    func selectedExcess_ty()
}

public class TYMediaCell_ty: TYCollectionViewCell_ty {
    /// 历史照片列表使用
    var model_ty: TYMediaModel_ty?
    /// 系统相册列表使用
    var assetMode_ty: PHAsset?

    weak var delegate_ty: TYPhotoAlbumCellDelegate_ty?

    private var disableShadowView_ty: TYView_ty = {
        let view_ty = TYView_ty()
        view_ty.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view_ty.isHidden        = true
        return view_ty
    }()
    var imageView_ty: UIImageView = {
        let imageView_ty = UIImageView()
        imageView_ty.contentMode = .scaleAspectFill
        imageView_ty.layer.masksToBounds = true
        return imageView_ty
    }()

    private var selectedBgView_ty: UIView = {
        let view_ty = UIView()
        view_ty.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view_ty.isHidden = true
        return view_ty
    }()

    private var iconLabel_ty: UILabel = {
        let label_ty = UILabel()
        label_ty.text          = "图标"
        label_ty.textColor     = UIColor.white
        label_ty.font          = UIFont.regular_ty(AdaptSize_ty(18))
        label_ty.textAlignment = .center
        label_ty.isHidden      = true
        return label_ty
    }()
    private var iconImageView_ty: TYImageView_ty = {
        let imageView_ty = TYImageView_ty()
        imageView_ty.contentMode = .scaleAspectFill
        return imageView_ty
    }()

    private var timeLabel_ty: UILabel = {
        let label_ty = UILabel()
        label_ty.text          = ""
        label_ty.textColor     = UIColor.white
        label_ty.font          = UIFont.regular_ty(AdaptSize_ty(10))
        label_ty.textAlignment = .left
        label_ty.isHidden      = true
        return label_ty
    }()

    private var selectButton_ty: TYButton_ty = {
        let button_ty = TYButton_ty()
        button_ty.setImage(UIImage(name_ty: "unselect_ty"), for: .normal)
        button_ty.setImage(UIImage(name_ty: "selected_ty"), for: .selected)
        button_ty.imageEdgeInsets = UIEdgeInsets(top: AdaptSize_ty(5), left: AdaptSize_ty(5), bottom: AdaptSize_ty(5), right: AdaptSize_ty(5))
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
        self.addSubview(imageView_ty)
        self.addSubview(selectedBgView_ty)
        self.addSubview(selectButton_ty)
        self.addSubview(iconLabel_ty)
        self.addSubview(timeLabel_ty)
        self.addSubview(disableShadowView_ty)
        imageView_ty.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(0.9)
            make.right.bottom.equalToSuperview().offset(-0.9)
        }
        selectedBgView_ty.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView_ty)
        }
        selectButton_ty.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(AdaptSize_ty(35))
        }
        iconLabel_ty.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize_ty(5))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-5))
            make.size.equalTo(CGSize(width: AdaptSize_ty(20), height: AdaptSize_ty(18)))
        }
        timeLabel_ty.snp.makeConstraints { (make) in
            make.left.equalTo(iconLabel_ty.snp.right).offset(AdaptSize_ty(5))
            make.centerY.equalTo(iconLabel_ty)
            make.right.equalToSuperview().offset(AdaptSize_ty(-10))
            make.height.equalTo(AdaptSize_ty(10))
        }
        disableShadowView_ty.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.imageView_ty.layer.masksToBounds = true
        self.selectButton_ty.addTarget(self, action: #selector(selectedImage_ty(sender_ty:)), for: .touchUpInside)
        let tapDisableGes_ty = UITapGestureRecognizer(target: self, action: #selector(boredAction_ty))
        self.disableShadowView_ty.addGestureRecognizer(tapDisableGes_ty)
    }

    // MARK: ==== Event ====
    @objc
    private func boredAction_ty() {
        self.delegate_ty?.selectedExcess_ty()
    }
    
    /// 显示历史照片浏览
    func setData_ty(model_ty: TYMediaModel_ty, hideSelect_ty: Bool, isSelected_ty: Bool) {
        self.model_ty                   = model_ty
        self.isSelected                 = isSelected_ty
        self.selectButton_ty.isHidden   = hideSelect_ty
        self.selectedBgView_ty.isHidden = hideSelect_ty
        
        switch model_ty.type_ty {
        case .video_ty:
            self.iconLabel_ty.isHidden = false
            self.timeLabel_ty.isHidden = false
            self.iconLabel_ty.text     = "视频"
//            if let videoModel = model as? TYMediaVideoModel_ty {
//                self.timeLabel.text = videoModel.time.minuteSecondStr()
//                videoModel.getCover(progress: nil) { [weak self] image in
//                    self?.imageView.image = image
//                }
//            }
        case .audio_ty:
            self.iconLabel_ty.isHidden  = false
            self.timeLabel_ty.isHidden  = false
            self.iconLabel_ty.text      = "音频"
            self.timeLabel_ty.text      = ""
        case .image_ty:
            self.iconLabel_ty.isHidden  = true
            self.timeLabel_ty.isHidden  = true
            self.iconLabel_ty.text      = ""
            self.timeLabel_ty.text      = ""
//            if let imageModel = model as? TYMediaImageModel_ty {
//                imageModel.getImage(progress: nil) {[weak self] (image: UIImage?) in
//                    self?.imageView.image = image
//                }
//            }
        default:
            break
        }
    }

    /// 显示系统相册中的照片
    func setData_ty(asset_ty: PHAsset, isSelected_ty: Bool, selectedMax_ty: Bool) {
        self.assetMode_ty               = asset_ty
        self.selectButton_ty.isSelected = isSelected_ty
        self.selectedBgView_ty.isHidden = !isSelected_ty
        self.imageView_ty.image         = nil
        self.timeLabel_ty.text          = asset_ty.duration.minuteSecondStr_ty()
        if selectedMax_ty && !isSelected_ty {
            self.disableShadowView_ty.isHidden = false
        } else {
            self.disableShadowView_ty.isHidden = true
        }
        
        if asset_ty.mediaType == .video || asset_ty.mediaType == .audio {
            self.iconLabel_ty.isHidden = false
            self.timeLabel_ty.isHidden = false
        } else {
            self.iconLabel_ty.isHidden = true
            self.timeLabel_ty.isHidden = true
        }
        
        self.iconLabel_ty.text = {
            if asset_ty.mediaType == .video {
                return "视频"
            } else if asset_ty.mediaType == .audio {
                return "音频"
            } else {
                return ""
            }
        }()
        self.timeLabel_ty.text = {
            if Int(asset_ty.duration) >= 3600 {
                return asset_ty.duration.hourMinuteSecondStr_ty()
            } else {
                return asset_ty.duration.minuteSecondStr_ty()
            }
        }()
        let imageSize_ty = (kScreenWidth_ty - 20) / 5.5 * UIScreen.main.scale
        let options_ty   = PHImageRequestOptions()
        options_ty.isSynchronous = false
        PHCachingImageManager.default().requestImage(for: asset_ty, targetSize: CGSize(width: imageSize_ty, height: imageSize_ty), contentMode: .default, options: options_ty) { [weak self] (image_ty: UIImage?, info_ty:[AnyHashable : Any]?) in
            self?.imageView_ty.image = image_ty
        }
    }

    @objc private func selectedImage_ty(sender_ty: TYButton_ty) {
        let _isSelected_ty = !sender_ty.isSelected
        var imageModel_ty: Any
        if let _model_ty = self.model_ty {
            imageModel_ty = _model_ty
        } else if let _model_ty = self.assetMode_ty {
            imageModel_ty = _model_ty
        } else {
            return
        }
        if _isSelected_ty {
            self.delegate_ty?.selectedImage_ty(model_ty: imageModel_ty)
        } else {
            self.delegate_ty?.unselectImage_ty(model_ty: imageModel_ty)
        }
    }

}

