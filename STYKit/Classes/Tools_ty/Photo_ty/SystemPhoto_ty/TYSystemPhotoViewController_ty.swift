//
//  TYSystemPhotoViewController_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Photos
import UIKit

/// 系统相册列表（包含相册选择）
public class TYSystemPhotoViewController_ty: TYViewController_ty, TYSystemAlbumListViewDelegate_ty, TYSystemPhotoViewDelegate_ty {

    /// 当前相册对象
    private var albumModel_ty: TYPhotoAlbumModel_ty? {
        willSet(newValue_ty) {
            self.contentView_ty.reload_ty(album_ty: newValue_ty)
        }
    }
    private var titleBackgroundView_ty: TYView_ty = {
        let view_ty = TYView_ty()
        view_ty.backgroundColor          = UIColor.gray0_ty
        view_ty.layer.masksToBounds      = true
        view_ty.isUserInteractionEnabled = false
        return view_ty
    }()
    /// 所有相册列表
    private var collectionList_ty: [TYPhotoAlbumModel_ty] = []
    /// 选择后的闭包回调
    var selectedBlock_ty:(([TYMediaModel_ty])->Void)?
    /// 最大选择数量
    var maxSelectCount_ty: Int   = 1
    ///是否自动消失
    var autoPop_ty: Bool         = true
    /// 相册列表视图
    private var albumListView_ty = TYSystemAlbumListView_ty()
    /// 内容视图
    private let contentView_ty   = TYSystemPhotoView_ty()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.bindData_ty()
    }

    public override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(contentView_ty)
        self.view.addSubview(albumListView_ty)
        contentView_ty.snp.makeConstraints { (make_ty) in
            make_ty.left.right.bottom.equalToSuperview()
            make_ty.top.equalToSuperview().offset(kNavigationHeight_ty)
        }
        albumListView_ty.snp.makeConstraints { (make_ty) in
            make_ty.left.right.bottom.equalToSuperview()
            make_ty.top.equalToSuperview().offset(kNavigationHeight_ty)
        }
        if let bar_ty = self.customNavigationBar_ty {
            bar_ty.addSubview(titleBackgroundView_ty)
            bar_ty.sendSubviewToBack(titleBackgroundView_ty)
            bar_ty.titleLabel_ty.font      = UIFont.regular_ty(AdaptSize_ty(15))
            bar_ty.titleLabel_ty.textColor = UIColor.black
            titleBackgroundView_ty.snp.makeConstraints { make_ty in
                make_ty.size.equalTo(CGSize.zero)
                make_ty.center.equalTo(self.customNavigationBar_ty!.titleLabel_ty)
            }
        }
    }

    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.albumListView_ty.delegate_ty       = self
        self.contentView_ty.delegate_ty         = self
        self.albumListView_ty.isHidden          = true
        self.contentView_ty.maxSelectCount_ty   = maxSelectCount_ty
        
        if let bar_ty = self.customNavigationBar_ty {
            // 标题 - 点击相册名可更换其他相册
            let tapAction_ty = UITapGestureRecognizer(target: self, action: #selector(self.switchAlbumList_ty))
            bar_ty.titleLabel_ty.isUserInteractionEnabled = true
            bar_ty.titleLabel_ty.addGestureRecognizer(tapAction_ty)
            // 右边按钮 - 确定选择
            bar_ty.rightButton_ty.setTitleColor(UIColor.white, for: .normal)
            bar_ty.rightButton_ty.layer.masksToBounds = true
            bar_ty.rightButton_ty.layer.cornerRadius  = AdaptSize_ty(5)
            bar_ty.rightButton_ty.backgroundColor     = UIColor.theme_ty
            // 左边按钮 - 返回
            bar_ty.setLeftTitle_ty(text_ty: "")
            bar_ty.leftButton_ty.setImage(UIImage(name_ty: "close_ty"), for: .normal)
            bar_ty.leftButton_ty.imageEdgeInsets = UIEdgeInsets(top: AdaptSize_ty(4), left: AdaptSize_ty(10), bottom: AdaptSize_ty(4), right: AdaptSize_ty(10))
            self.updateRightButtonStatus_ty()
        }
    }

    public override func bindData_ty() {
        super.bindData_ty()
        // 获取相册列表
        self.setAssetCollection_ty { [weak self] in
            guard let self = self, !self.collectionList_ty.isEmpty else {
                return
            }
            // 设置默认显示的相册
            self.albumModel_ty = self.collectionList_ty.first
            self.albumListView_ty.setData_ty(albumList_ty: self.collectionList_ty, current_ty: self.albumModel_ty)
            self.albumListView_ty.tableView_ty.reloadData()
            self.updateTitleView_ty()
        }
    }
    
    public override func leftAction_ty() {
        super.leftAction_ty()
    }

    public override func rightAction_ty() {
        super.rightAction_ty()
        let group_ty = DispatchGroup()
        var mediaModelList_ty = [TYMediaModel_ty]()
        let assetModelList_ty = self.contentView_ty.selectedPhotoList()
        
        self.view.showLoading_ty()
        assetModelList_ty.forEach { (asset_ty) in
            group_ty.enter()
            self.assetTransforMediaModel_ty(asset_ty: asset_ty) { model_ty in
                guard let _model_ty = model_ty else {
                    group_ty.leave()
                    return
                }
                mediaModelList_ty.append(_model_ty)
                group_ty.leave()
            }
        }
        group_ty.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            var result = true
            mediaModelList_ty.forEach { model_ty in
                if let imageModel_ty = model_ty as? TYMediaImageModel_ty, let _image_ty = imageModel_ty.image_ty {
                    if (imageModel_ty.data_ty?.sizeMB_ty ?? 0 > 30) {
                        kWindow_ty.toast_ty("部分图片太大，请重新选择")
                        result = false
                    } else if (imageModel_ty.data_ty?.sizeKB_ty ?? 0 > 500) {
                        if let finalImageData_ty = _image_ty.compress_ty(size_ty: CGSize(width: 800.0, height: 800.0), compressionQuality_ty: 0.5) {
                            imageModel_ty.image_ty = UIImage(data: finalImageData_ty)
                        }
                    }
                }
            }
            self.view.hideLoading_ty()
            if result {
                self.selectedBlock_ty?(mediaModelList_ty)
                if (self.autoPop_ty) {
                    self.leftAction_ty()
                }
            }
        }
    }

    // MARK: ==== Event ====
    /// 设置相册列表
    private func setAssetCollection_ty(complete_ty block_ty: DefaultBlock_ty?) {
        TYAuthorizationManager_ty.share_ty.photo_ty { [weak self] (result_ty) in
            guard let self = self, result_ty else { return }
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                // 收藏相册
                let favoritesCollections_ty = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
                // 相机照片
                let assetCollections_ty     = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumUserLibrary, options: nil)
                // 全部照片
                let cameraRolls_ty          = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
                var id_ty: Int = 0
                cameraRolls_ty.enumerateObjects { [weak self] (collection_ty: PHAssetCollection, index_ty: Int, pointer_ty: UnsafeMutablePointer<ObjCBool>) in
                    id_ty += 1
                    let model_ty = TYPhotoAlbumModel_ty(collection_ty: collection_ty)
                    model_ty.id_ty = id_ty
                    self?.collectionList_ty.append(model_ty)
                }
                favoritesCollections_ty.enumerateObjects { [weak self] (collection_ty: PHAssetCollection, index_ty: Int, pointer_ty: UnsafeMutablePointer<ObjCBool>) in
                    id_ty += 1
                    let model_ty = TYPhotoAlbumModel_ty(collection_ty: collection_ty)
                    model_ty.id_ty = id_ty
                    self?.collectionList_ty.append(model_ty)
                }
                assetCollections_ty.enumerateObjects { [weak self] (collection_ty: PHAssetCollection, index_ty: Int, pointer_ty: UnsafeMutablePointer<ObjCBool>) in
                    id_ty += 1
                    let model_ty = TYPhotoAlbumModel_ty(collection_ty: collection_ty)
                    model_ty.id_ty = id_ty
                    self?.collectionList_ty.append(model_ty)
                }
                DispatchQueue.main.async {
                    block_ty?()
                }
            }
        }
    }
    
    @objc private func switchAlbumList_ty() {
        if self.albumListView_ty.isHidden {
            self.albumListView_ty.showView_ty()
        } else {
            self.albumListView_ty.hideView_ty()
        }
    }
    
    /// 更新右上角确定按钮的状态
    private func updateRightButtonStatus_ty() {
        let list_ty  = self.contentView_ty.selectedPhotoList()
        var title_ty = "完成"
        if list_ty.isEmpty {
            self.customNavigationBar_ty?.rightButton_ty.status_ty = .disable_ty
        } else {
            title_ty += "(\(list_ty.count)/\(self.maxSelectCount_ty))"
            self.customNavigationBar_ty?.rightButton_ty.status_ty = .normal_ty
        }
        if let bar_ty = self.customNavigationBar_ty {
            bar_ty.setRightTitle_ty(text_ty: title)
        }
    }
    
    /// 更新标题
    private func updateTitleView_ty() {
        if self.albumListView_ty.isHidden {
            self.customNavigationBar_ty?.title_ty = (self.albumModel_ty?.assetCollection_ty?.localizedTitle ?? "")
        } else {
            self.customNavigationBar_ty?.title_ty = (self.albumModel_ty?.assetCollection_ty?.localizedTitle ?? "")
        }
        if let _titleLabel_ty = self.customNavigationBar_ty?.titleLabel_ty, let _title_ty = _titleLabel_ty.text {
            let _width_ty = _title_ty.textWidth_ty(font_ty: _titleLabel_ty.font, height_ty: _titleLabel_ty.font.lineHeight)
            let _size_ty = CGSize(width: _width_ty + AdaptSize_ty(20), height: _titleLabel_ty.font.lineHeight + AdaptSize_ty(10))
            self.titleBackgroundView_ty.snp.updateConstraints { make_ty in
                make_ty.size.equalTo(_size_ty)
            }
            self.titleBackgroundView_ty.layer.cornerRadius = _size_ty.height/2
        }
    }

    // MARK: ==== Tools ====
    /// 转换得到资源对象
    private func assetTransforMediaModel_ty(asset_ty: PHAsset, complete_ty block_ty: ((TYMediaModel_ty?)->Void)?) {
        switch asset_ty.mediaType {
        case .image:
            self.getImage_ty(asset_ty: asset_ty, complete_ty: block_ty)
        case .video:
            self.getVideo_ty(asset_ty: asset_ty, complete_ty: block_ty)
        default:
            block_ty?(nil)
            break
        }
    }
    
    /// 获取图片
    private func getImage_ty(asset_ty: PHAsset, complete_ty block_ty: ((TYMediaImageModel_ty?)->Void)?) {
        var model_ty: TYMediaImageModel_ty?
        let options_ty = PHImageRequestOptions()
        options_ty.deliveryMode           = .highQualityFormat
        options_ty.isSynchronous          = true
        options_ty.resizeMode             = .exact
        options_ty.isNetworkAccessAllowed = true
        options_ty.progressHandler = { (progress_ty, error_ty, stop_ty, userInfo_ty:[AnyHashable : Any]?) in
            print("Progress: \(progress_ty)")
        }
//        PHCachingImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image: UIImage?, info:[AnyHashable : Any]?) in
//            guard let result = info as? [String: Any], (result[PHImageCancelledKey] == nil), (result[PHImageErrorKey] == nil) else {
//                block?(nil)
//                return
//            }
//            let mediaModel = TYMediaImageModel_ty()
//            mediaModel.image = image
//            mediaModel.name  = asset.value(forKey: "filename") as? String ?? ""
//            mediaModel.type  = .image(type: .originImage)
//            model = mediaModel
//            block?(model)
//        }
        PHImageManager.default().requestImageData(for: asset_ty, options: options_ty) { data_ty, str_ty, ori_ty, info_ty in
            print(data_ty?.sizeMB_ty ?? 0)
            guard let data_ty = data_ty else {
                block_ty?(nil)
                return
            }
            let mediaModel_ty = TYMediaImageModel_ty()
            mediaModel_ty.image_ty = UIImage(data: data_ty)
            mediaModel_ty.name_ty  = asset_ty.value(forKey: "filename") as? String ?? ""
            mediaModel_ty.type_ty  = .image_ty(type_ty: .originImage_ty)
            mediaModel_ty.data_ty  = data_ty
            model_ty = mediaModel_ty
            block_ty?(model_ty)
        }
    }
    
    /// 获取视频
    private func getVideo_ty(asset_ty: PHAsset, complete_ty block_ty: ((TYMediaModel_ty?)->Void)?) {
        guard let resource_ty = PHAssetResource.assetResources(for: asset_ty).first else {
            block_ty?(nil)
            return
        }
        var videoData_ty: Data?
        let option_ty = PHAssetResourceRequestOptions()
        option_ty.isNetworkAccessAllowed = true
        
        PHAssetResourceManager.default().requestData(for: resource_ty, options: option_ty) { data_ty in
            videoData_ty = data_ty
        } completionHandler: { error_ty in
            guard error_ty == nil, let _data_ty = videoData_ty else {
                block_ty?(nil)
                return
            }
            let model_ty = TYMediaVideoModel_ty()
            model_ty.data_ty = _data_ty
            model_ty.name_ty = resource_ty.originalFilename
            model_ty.type_ty = .video_ty
            block_ty?(model_ty)
        }
    }
    
    // MARK: ==== TYSystemPhotoViewDelegate_ty ====
    public func clickImage_ty(indexPath_ty: IndexPath, from_ty imageView_ty: UIImageView?) {
        guard let model_ty = self.albumModel_ty else { return }
        TYBrowserView_ty(type_ty: .system_ty(result_ty: model_ty.assets_ty), current_ty: indexPath_ty.row).show_ty(animationView_ty: imageView_ty)
    }
    
    public func selectedImage_ty() {
        self.updateRightButtonStatus_ty()
    }
    public func unselectImage_ty() {
        self.updateRightButtonStatus_ty()
    }

    // MARK: ==== TYSystemAlbumListViewDelegate_ty ====
    public func selectedAlbum_ty(model_ty: TYPhotoAlbumModel_ty?) {
        self.albumModel_ty = model_ty
        self.updateTitleView_ty()
    }
    
    public func showAlbumAction_ty() {
        self.updateTitleView_ty()
    }
    
    public func hideAlbumAction_ty() {
        self.updateTitleView_ty()
    }

}
