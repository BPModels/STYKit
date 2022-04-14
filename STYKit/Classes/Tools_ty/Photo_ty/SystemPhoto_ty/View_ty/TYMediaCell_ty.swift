//
//  TYMediaCell_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Photos
import UIKit

public protocol TYPhotoAlbumCellDelegate_ty: NSObjectProtocol {
    func selectedImage_ty(model: Any)
    func unselectImage_ty(model: Any)
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
        let view = TYView_ty()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view.isHidden        = true
        return view
    }()
    var imageView_ty: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private var selectedBgView_ty: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.isHidden = true
        return view
    }()

    private var iconLabel_ty: UILabel = {
        let label = UILabel()
        label.text          = "图标"
        label.textColor     = UIColor.white
        label.font          = UIFont.regular_ty(size: AdaptSize_ty(18))
        label.textAlignment = .center
        label.isHidden      = true
        return label
    }()
    private var iconImageView_ty: TYImageView_ty = {
        let imageView = TYImageView_ty()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private var timeLabel_ty: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regular_ty(size: AdaptSize_ty(10))
        label.textAlignment = .left
        label.isHidden      = true
        return label
    }()

    private var selectButton_ty: TYButton_ty = {
        let button = TYButton_ty()
        button.setImage(UIImage(named: "unselectImage"), for: .normal)
        button.setImage(UIImage(named: "selectedImage"), for: .selected)
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
        self.selectButton_ty.addTarget(self, action: #selector(selectedImage(sender:)), for: .touchUpInside)
        let tapDisableGes = UITapGestureRecognizer(target: self, action: #selector(boredAction_ty))
        self.disableShadowView_ty.addGestureRecognizer(tapDisableGes)
    }

    // MARK: ==== Event ====
    @objc
    private func boredAction_ty() {
        self.delegate_ty?.selectedExcess_ty()
    }
    
    /// 显示历史照片浏览
    func setData_ty(model: TYMediaModel_ty, hideSelect: Bool, isSelected: Bool) {
        self.model_ty                   = model
        self.isSelected                 = isSelected
        self.selectButton_ty.isHidden   = hideSelect
        self.selectedBgView_ty.isHidden = hideSelect
        
        switch model.type_ty {
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
            self.iconLabel_ty.isHidden = false
            self.timeLabel_ty.isHidden = false
            self.iconLabel_ty.text = "音频"
            self.timeLabel_ty.text = ""
        case .image_ty:
            self.iconLabel_ty.isHidden = true
            self.timeLabel_ty.isHidden = true
            self.iconLabel_ty.text = ""
            self.timeLabel_ty.text = ""
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
    func setData_ty(asset: PHAsset, isSelected: Bool, selectedMax: Bool) {
        self.assetMode_ty               = asset
        self.selectButton_ty.isSelected = isSelected
        self.selectedBgView_ty.isHidden = !isSelected
        self.imageView_ty.image         = nil
        self.timeLabel_ty.text          = asset.duration.minuteSecondStr_ty()
        if selectedMax && !isSelected {
            self.disableShadowView_ty.isHidden = false
        } else {
            self.disableShadowView_ty.isHidden = true
        }
        
        if asset.mediaType == .video || asset.mediaType == .audio {
            self.iconLabel_ty.isHidden = false
            self.timeLabel_ty.isHidden = false
        } else {
            self.iconLabel_ty.isHidden = true
            self.timeLabel_ty.isHidden = true
        }
        
        self.iconLabel_ty.text = {
            if asset.mediaType == .video {
                return "视频"
            } else if asset.mediaType == .audio {
                return "音频"
            } else {
                return ""
            }
        }()
        self.timeLabel_ty.text = {
            if Int(asset.duration) >= 3600 {
                return asset.duration.hourMinuteSecondStr_ty()
            } else {
                return asset.duration.minuteSecondStr_ty()
            }
        }()
        let imageSize = (kScreenWidth_ty - 20) / 5.5 * UIScreen.main.scale
        let options   = PHImageRequestOptions()
        options.isSynchronous = false
        PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: imageSize, height: imageSize), contentMode: .default, options: options) { [weak self] (image: UIImage?, info:[AnyHashable : Any]?) in
            self?.imageView_ty.image = image
        }
    }

    @objc private func selectedImage(sender: TYButton_ty) {
        let _isSelected = !sender.isSelected
        var imageModel: Any
        if let _model = self.model_ty {
            imageModel = _model
        } else if let _model = self.assetMode_ty {
            imageModel = _model
        } else {
            return
        }
        if _isSelected {
            self.delegate_ty?.selectedImage_ty(model: imageModel)
        } else {
            self.delegate_ty?.unselectImage_ty(model: imageModel)
        }
    }

}

