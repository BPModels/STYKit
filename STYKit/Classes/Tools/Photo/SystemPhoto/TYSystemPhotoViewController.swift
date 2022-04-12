//
//  TYSystemPhotoViewController.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Photos
import UIKit

class TYSystemPhotoViewController: TYViewController, TYSystemAlbumListViewDelegate, TYSystemPhotoViewDelegate {

    /// 当前相册对象
    private var albumModel_ty: TYPhotoAlbumModel? {
        willSet {
            self.contentView_ty.reload(album: newValue)
        }
    }
    private var titleBackgroundView_ty: TYView = {
        let view = TYView()
        view.backgroundColor = UIColor.gray0_ty
        view.layer.masksToBounds      = true
        view.isUserInteractionEnabled = false
        return view
    }()
    /// 所有相册列表
    private var collectionList_ty: [TYPhotoAlbumModel] = []
    /// 选择后的闭包回调
    var selectedBlock_ty:(([TYMediaModel])->Void)?
    /// 最大选择数量
    var maxSelectCount_ty: Int = 1
    ///是否自动消失
    var autoPop_ty: Bool = true
    ///页面跳转方式
    var push_ty: Bool = true
    /// 相册列表视图
    private var albumListView_ty = TYSystemAlbumListView()
    /// 内容视图
    private let contentView_ty   = TYSystemPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.bindData_ty()
    }

    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(contentView_ty)
        self.view.addSubview(albumListView_ty)
        contentView_ty.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight_ty)
        }
        albumListView_ty.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight_ty)
        }
        if let bar = self.customNavigationBar_ty {
            bar.addSubview(titleBackgroundView_ty)
            bar.sendSubviewToBack(titleBackgroundView_ty)
            bar.titleLabel_ty.font      = UIFont.custom_ty(.PingFangTCRegular, size: AdaptSize_ty(15))
            bar.titleLabel_ty.textColor = UIColor.black
            titleBackgroundView_ty.snp.makeConstraints { make in
                make.size.equalTo(CGSize.zero)
                make.center.equalTo(self.customNavigationBar_ty!.titleLabel_ty)
            }
            
        }
    }

    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.albumListView_ty.delegate_ty  = self
        self.contentView_ty.delegate_ty    = self
        self.albumListView_ty.isHidden     = true
        self.contentView_ty.maxSelectCount_ty = maxSelectCount_ty
        // 点击相册名可更换其他相册
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.switchAlbumList))
        if let bar = self.customNavigationBar_ty {
            bar.titleLabel_ty.isUserInteractionEnabled = true
            bar.titleLabel_ty.addGestureRecognizer(tapAction)
            // 确定选择
            bar.rightButton_ty.setTitleColor(UIColor.white, for: .normal)
            bar.rightButton_ty.layer.masksToBounds = true
            bar.setLeftTitle_ty(text: "")
            bar.leftButton_ty.setImage(UIImage(named: "photo_album_close_icon"), for: .normal)
            self.updateRightButtonStatus()
        }
    }

    override func bindData_ty() {
        super.bindData_ty()
        // 获取相册列表
        self.setAssetCollection { [weak self] in
            guard let self = self, !self.collectionList_ty.isEmpty else {
                return
            }
            // 设置默认显示的相册
            self.albumModel_ty = self.collectionList_ty.first
            self.albumListView_ty.setData_ty(albumList: self.collectionList_ty, current: self.albumModel_ty)
            self.albumListView_ty.tableView_ty.reloadData()
            self.updateTitleView()
        }
    }
    
    override func leftAction_ty() {
        if (self.push_ty) {
            super.leftAction_ty()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func rightAction_ty() {
        super.rightAction_ty()
        let group = DispatchGroup()
        var mediaModelList = [TYMediaModel]()
        let assetModelList = self.contentView_ty.selectedPhotoList()
        
        self.view.showLoading_ty()
        assetModelList.forEach { (asset) in
            group.enter()
            self.assetTransforMediaModel(asset: asset) { model in
                guard let _model = model else {
                    group.leave()
                    return
                }
                mediaModelList.append(_model)
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            var result = true
            mediaModelList.forEach { model in
                if let imageModel = model as? TYMediaImageModel, let _image = imageModel.image_ty {
                    if (imageModel.data_ty?.sizeMB_ty ?? 0 > 30) {
                        kWindow_ty.toast_ty("部分图片太大，请重新选择")
                        result = false
                    } else if (imageModel.data_ty?.sizeKB_ty ?? 0 > 500) {
                        if let finalImageData = _image.compress_ty(size: CGSize(width: 800.0, height: 800.0), compressionQuality: 0.5) {
                            imageModel.image_ty = UIImage(data: finalImageData)
                        }
                    }
                }
            }
            self.view.hideLoading_ty()
            if result {
                self.selectedBlock_ty?(mediaModelList)
                if (self.autoPop_ty) {
                    currentNVC_ty?.pop_ty()
                }
            }
        }
    }

    // MARK: ==== Event ====
    /// 设置相册列表
    private func setAssetCollection(complete block: DefaultBlock_ty?) {
        TYAuthorizationManager.share_ty.photo_ty { [weak self] (result) in
            guard let self = self, result else { return }
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                // 收藏相册
                let favoritesCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
                // 相机照片
                let assetCollections     = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumUserLibrary, options: nil)
                // 全部照片
                let cameraRolls          = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
                var id: Int = 0
                cameraRolls.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    id += 1
                    let model = TYPhotoAlbumModel(collection: collection)
                    model.id_ty = id
                    self?.collectionList_ty.append(model)
                }
                favoritesCollections.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    id += 1
                    let model = TYPhotoAlbumModel(collection: collection)
                    model.id_ty = id
                    self?.collectionList_ty.append(model)
                }
                assetCollections.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    id += 1
                    let model = TYPhotoAlbumModel(collection: collection)
                    model.id_ty = id
                    self?.collectionList_ty.append(model)
                }
                DispatchQueue.main.async {
                    block?()
                }
            }
        }
    }
    
    @objc private func switchAlbumList() {
        if self.albumListView_ty.isHidden {
            self.albumListView_ty.showView_ty()
        } else {
            self.albumListView_ty.hideView_ty()
        }
    }
    
    /// 更新右上角确定按钮的状态
    private func updateRightButtonStatus() {
        let list = self.contentView_ty.selectedPhotoList()
        var title = "完成"
        if list.isEmpty {
            self.customNavigationBar_ty?.rightButton_ty.status = .disable
        } else {
            title += "(\(list.count)/\(self.maxSelectCount_ty))"
            self.customNavigationBar_ty?.rightButton_ty.status = .normal
        }
        if let bar = self.customNavigationBar_ty {
            bar.setRightTitle_ty(text: title) 
//            let _width = bar.rightButton.sizeThatFits(CGSize(width: kScreenWidth, height: AdaptSize_ty(27))).width
//            let rightButtonSize = CGSize(width: _width + AdaptSize_ty(10), height: AdaptSize_ty(27))
//            bar.rightButton.layer.cornerRadius = rightButtonSize.height/2
//            bar.rightButton.backgroundColor    = UIColor.gradientColor(with: rightButtonSize, colors: UIColor.themeGradientList, direction: .horizontal)
        }
    }
    
    /// 更新标题
    private func updateTitleView() {
        if self.albumListView_ty.isHidden {
            self.customNavigationBar_ty?.title = (self.albumModel_ty?.assetCollection_ty?.localizedTitle ?? "") + "下"
        } else {
            self.customNavigationBar_ty?.title = (self.albumModel_ty?.assetCollection_ty?.localizedTitle ?? "") + "上"
        }
        if let _titleLabel = self.customNavigationBar_ty?.titleLabel_ty, let _title = _titleLabel.text {
            let _width = _title.textWidth_ty(font: _titleLabel.font, height: _titleLabel.font.lineHeight)
            let _size = CGSize(width: _width + AdaptSize_ty(20), height: _titleLabel.font.lineHeight + AdaptSize_ty(10))
            self.titleBackgroundView_ty.snp.updateConstraints { make in
                make.size.equalTo(_size)
            }
            self.titleBackgroundView_ty.layer.cornerRadius = _size.height/2
        }
    }

    // MARK: ==== Tools ====
    /// 转换得到资源对象
    private func assetTransforMediaModel(asset: PHAsset, complete block: ((TYMediaModel?)->Void)?) {
        switch asset.mediaType {
        case .image:
            self.getImage(asset: asset, complete: block)
        case .video:
            self.getVideo(asset: asset, complete: block)
        default:
            block?(nil)
            break
        }
    }
    
    /// 获取图片
    private func getImage(asset: PHAsset, complete block: ((TYMediaImageModel?)->Void)?) {
        var model: TYMediaImageModel?
        let options = PHImageRequestOptions()
        options.deliveryMode           = .highQualityFormat
        options.isSynchronous          = true
        options.resizeMode             = .exact
        options.isNetworkAccessAllowed = true
        options.progressHandler = { (progress, error, stop, userInfo:[AnyHashable : Any]?) in
            print("Progress: \(progress)")
        }
//        PHCachingImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image: UIImage?, info:[AnyHashable : Any]?) in
//            guard let result = info as? [String: Any], (result[PHImageCancelledKey] == nil), (result[PHImageErrorKey] == nil) else {
//                block?(nil)
//                return
//            }
//            let mediaModel = TYMediaImageModel()
//            mediaModel.image = image
//            mediaModel.name  = asset.value(forKey: "filename") as? String ?? ""
//            mediaModel.type  = .image(type: .originImage)
//            model = mediaModel
//            block?(model)
//        }
        PHImageManager.default().requestImageData(for: asset, options: options) { data, str, ori, info in
            print(data?.sizeMB_ty ?? 0)
            guard let data = data else {
                block?(nil)
                return
            }
            let mediaModel = TYMediaImageModel()
            mediaModel.image_ty = UIImage(data: data)
            mediaModel.name_ty  = asset.value(forKey: "filename") as? String ?? ""
            mediaModel.type_ty  = .image_ty(type: .originImage_ty)
            mediaModel.data_ty  = data
            model = mediaModel
            block?(model)
        }
    }
    
    /// 获取视频
    private func getVideo(asset: PHAsset, complete block: ((TYMediaModel?)->Void)?) {
        guard let resource = PHAssetResource.assetResources(for: asset).first else {
            block?(nil)
            return
        }
        var videoData: Data?
        let option = PHAssetResourceRequestOptions()
        option.isNetworkAccessAllowed = true
        
        PHAssetResourceManager.default().requestData(for: resource, options: option) { data in
            videoData = data
        } completionHandler: { error in
            guard error == nil, let _data = videoData else {
                block?(nil)
                return
            }
            let model = TYMediaVideoModel()
            model.data_ty = _data
            model.name_ty = resource.originalFilename
            model.type_ty = .video_ty
            block?(model)
        }
    }
    
    // MARK: ==== TYSystemPhotoViewDelegate ====
    func clickImage_ty(indexPath: IndexPath, from imageView: UIImageView?) {
        guard let model = self.albumModel_ty else { return }
        TYBrowserView(type: .system_ty(result: model.assets_ty), current: indexPath.row).show_ty(animationView: imageView)
    }
    
    func selectedImage_ty() {
        self.updateRightButtonStatus()
    }
    func unselectImage_ty() {
        self.updateRightButtonStatus()
    }

    // MARK: ==== TYSystemAlbumListViewDelegate ====
    func selectedAlbum_ty(model: TYPhotoAlbumModel?) {
        self.albumModel_ty = model
        self.updateTitleView()
    }
    
    func showAlbumAction_ty() {
        self.updateTitleView()
    }
    
    func hideAlbumAction_ty() {
        self.updateTitleView()
    }

}
