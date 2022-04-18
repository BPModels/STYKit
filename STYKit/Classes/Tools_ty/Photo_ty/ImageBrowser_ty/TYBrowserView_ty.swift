//
//  TYBrowserView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import UIKit
import Photos

public enum TYImageBrowserType_ty {
    /// 自定义
    case custom_ty(modelList_ty: [TYMediaModel_ty])
    /// 系统相册
    case system_ty(result_ty: [PHAsset])
}

public protocol TYImageBrowserDelegate_ty: NSObjectProtocol {
    func reuploadImage(model_ty:[TYMediaModel_ty])
}

public class TYBrowserView_ty:
    TYView_ty,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    TYBrowserImageCellDelegate_ty,
    TYBrowserVideoCellDelegate_ty {
    
    public weak var delegate_ty:TYImageBrowserDelegate_ty?
    
    private let kTYBrowserImageCellID_ty = "kTYBrowserImageCellID_ty"
    private let kTYBrowserVideoCellID_ty = "kTYBrowserVideoCellID_ty"
    private var medioModelList_ty: [TYMediaModel_ty] = []
    private var assetModelList_ty: PHFetchResult<PHAsset>?
    private var type_ty: TYImageBrowserType_ty
    private var currentIndex_ty: Int
    private var startFrame_ty: CGRect?
    
    var collectionView_ty: UICollectionView = {
        let layout_ty = UICollectionViewFlowLayout()
        layout_ty.itemSize           = kWindow_ty.size_ty
        layout_ty.scrollDirection    = .horizontal
        layout_ty.minimumLineSpacing = .zero
//        layout.minimumInteritemSpacing = AdaptSize_ty(20)
        let collectionView_ty = UICollectionView(frame: .zero, collectionViewLayout: layout_ty)
        collectionView_ty.showsHorizontalScrollIndicator = false
        collectionView_ty.showsVerticalScrollIndicator   = false
        collectionView_ty.isPagingEnabled  = true
        collectionView_ty.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleWidth, .flexibleHeight)
        collectionView_ty.backgroundColor  = .clear
        collectionView_ty.isHidden         = true
        return collectionView_ty
    }()
    
    
    private var backgroundView_ty: UIView = {
        let view_ty = UIView()
        view_ty.backgroundColor = UIColor.black
        return view_ty
    }()
    
    private var albumButton_ty: TYButton_ty = {
        let button_ty = TYButton_ty()
        button_ty.setTitle("全部", for: .normal)
        button_ty.setTitleColor(UIColor.white, for: .normal)
        button_ty.titleLabel?.font   = UIFont.regular_ty(AdaptSize_ty(14))
        button_ty.backgroundColor    = UIColor.black0_ty.withAlphaComponent(0.9)
        button_ty.layer.cornerRadius = AdaptSize_ty(5)
        button_ty.isHidden           = true
        return button_ty
    }()
    
    public init(type_ty: TYImageBrowserType_ty, current_ty index_ty: Int) {
        self.type_ty         = type_ty
        self.currentIndex_ty = index_ty
        super.init(frame: .zero)
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.bindData_ty()
        self.updateUI_ty()
//        TYChatRequestManager.share.requestRecord(content: "查看图片大图")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(backgroundView_ty)
        self.addSubview(collectionView_ty)
        
        self.addSubview(albumButton_ty)
        backgroundView_ty.snp.makeConstraints { (make_ty) in
            make_ty.edges.equalToSuperview()
        }
        collectionView_ty.snp.makeConstraints { (make_ty) in
            make_ty.edges.equalToSuperview()
        }
        
        albumButton_ty.snp.makeConstraints { (make_ty) in
            make_ty.top.equalToSuperview().offset(AdaptSize_ty(40))
            make_ty.right.equalToSuperview().offset(-AdaptSize_ty(20))
            make_ty.size.equalTo(CGSize(width: AdaptSize_ty(40), height: AdaptSize_ty(25)))
        }
    }
    
    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.collectionView_ty.delegate   = self
        self.collectionView_ty.dataSource = self
        self.collectionView_ty.register(TYBrowserImageCell_ty.classForCoder(), forCellWithReuseIdentifier: kTYBrowserImageCellID_ty)
        self.collectionView_ty.register(TYBrowserVideoCell_ty.classForCoder(), forCellWithReuseIdentifier: kTYBrowserVideoCellID_ty)
        self.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleHeight, .flexibleWidth)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.scrollToCurrentPage_ty()
        }
        self.albumButton_ty.addTarget(self, action: #selector(self.showAlubmVC_ty), for: .touchUpInside)
    }
    
    public override func bindData_ty() {
        super.bindData_ty()
        self.collectionView_ty.reloadData()
    }
    
    public override func updateUI_ty() {
        super.updateUI_ty()
        self.backgroundColor = .clear
    }
    
    // MARK: ==== Animation ====
    private func showAnimation_ty(startView_ty: UIImageView) {
        self.startFrame_ty = startView_ty.convert(startView_ty.bounds, to: kWindow_ty)
        // 做动画的视图
        let imageView_ty = UIImageView()
        imageView_ty.frame       = startFrame_ty ?? CGRect(origin: .zero, size: kWindow_ty.size_ty)
        imageView_ty.image       = startView_ty.image
        imageView_ty.contentMode = .scaleAspectFit
        self.addSubview(imageView_ty)
        self.collectionView_ty.isHidden = true
        UIView.animate(withDuration: 0.25) {
            imageView_ty.frame = CGRect(origin: .zero, size: kWindow_ty.size_ty)
        } completion: { [weak self] (finished_ty) in
            if (finished_ty) {
                imageView_ty.removeFromSuperview()
                self?.collectionView_ty.isHidden = false
            }
        }
    }
    
    private func hideAnimation_ty(view_ty: UIView) {
        guard let startFrame_ty = self.startFrame_ty else {
            self.hide_ty()
            return
        }
        let imageView_ty = UIImageView()
        imageView_ty.frame       = view_ty.frame
        imageView_ty.image       = view_ty.toImage_ty()
        imageView_ty.contentMode = .scaleAspectFit
        self.addSubview(imageView_ty)
        self.collectionView_ty.isHidden = true
        UIView.animate(withDuration: 0.25) { [weak self] in
            imageView_ty.frame = startFrame_ty
            self?.backgroundView_ty.layer.opacity = 0.0
        } completion: { [weak self] (finished_ty) in
            guard let self = self else { return }
            if (finished_ty) {
                imageView_ty.removeFromSuperview()
                self.layer.opacity = 0.0
                self.hide_ty()
            }
        }
    }
    
    // MARK: ==== Event ====
    
    /// 显示入场动画
    /// - Parameter animationView: 动画参考对象
    public func show_ty(animationView_ty: UIImageView?) {
        kWindow_ty.addSubview(self)
        self.snp.makeConstraints { (make_ty) in
            make_ty.edges.equalToSuperview()
        }
        guard let imageView_ty = animationView_ty else {
            return
        }
        // 显示进入动画
        self.showAnimation_ty(startView_ty: imageView_ty)
    }
    
    @objc
    public func hide_ty() {
        self.removeFromSuperview()
    }
    
    @objc
    private func showAlubmVC_ty() {
        let vc_ty = TYPhotoAlbumViewController_ty()
        vc_ty.modelList_ty = self.medioModelList_ty
        currentNVC_ty?.pushViewController(vc_ty, animated: true)
    }
    
    
    // MARK: ==== Tools ====
    private func scrollToCurrentPage_ty() {
        let offsetX_ty = kWindow_ty.width_ty * CGFloat(self.currentIndex_ty)
        self.collectionView_ty.contentOffset = CGPoint(x: offsetX_ty, y: 0)
    }
    
    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type_ty {
        case .custom_ty(let modelList_ty):
            return modelList_ty.count
        case .system_ty(let result_ty):
            return result_ty.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch type_ty {
        case .custom_ty(let modelList_ty):
            let model_ty = modelList_ty[indexPath.row]
            switch model_ty.type_ty {
            case .image_ty:
                guard let cell_ty = collectionView.dequeueReusableCell(withReuseIdentifier: kTYBrowserImageCellID_ty, for: indexPath) as? TYBrowserImageCell_ty, let imageModel_ty = model_ty as? TYMediaImageModel_ty else {
                    return TYCollectionViewCell_ty()
                }
                cell_ty.delegate_ty = self
                cell_ty.setCustomData_ty(model_ty: imageModel_ty, userId_ty: "")
                return cell_ty
            case .video_ty:
                guard let cell_ty = collectionView.dequeueReusableCell(withReuseIdentifier: kTYBrowserVideoCellID_ty, for: indexPath) as? TYBrowserVideoCell_ty, let videoModel_ty = model_ty as? TYMediaVideoModel_ty else {
                    return TYCollectionViewCell_ty()
                }
                cell_ty.setData_ty(model: videoModel_ty)
                cell_ty.delegate_ty = self
                return cell_ty
            default:
                return TYBrowserImageCell_ty()
            }
        case .system_ty(let result_ty):
            guard let cell_ty = collectionView.dequeueReusableCell(withReuseIdentifier: kTYBrowserImageCellID_ty, for: indexPath) as? TYBrowserImageCell_ty else {
                return TYCollectionViewCell_ty()
            }
            cell_ty.delegate_ty = self
            let asset_ty: PHAsset = result_ty[indexPath.row]
            cell_ty.setSystemData_ty(asset_ty: asset_ty)
            return cell_ty
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? TYBrowserImageCell_ty)?.updateZoomScale_ty()
    }
    
    // 滑动结束通知Cell
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
    // MARK: ==== TYBrowserVideoCellDelegate ====
    func videoViewClosedAction_ty(view_ty: UIView) {
        if self.startFrame_ty != nil {
            self.hideAnimation_ty(view_ty: view_ty)
        } else {
            self.hide_ty()
        }
    }
    
    func videoViewLongPressAction_ty(model_ty: TYMediaVideoModel_ty?) {
        print("保存视频暂未适配")
    }
    
    @objc private func savedVideoFinished_ty() {
        print("保存成功")
    }
    
    public func closeAction_ty(view_ty: UIView) {
        if self.startFrame_ty != nil {
            self.hideAnimation_ty(view_ty: view_ty)
        } else {
            self.hide_ty()
        }
    }
    
    // MARK: ==== TYImageBrowserCellDelegate ====
    public func clickAction_ty(view_ty: UIView) {
        if self.startFrame_ty != nil {
            self.hideAnimation_ty(view_ty: view_ty)
        } else {
            self.hide_ty()
        }
    }
    
    public func longPressAction_ty(image_ty: UIImage?) {
        TYActionSheet_ty().addItem_ty(title_ty: "保存") {
            guard let _image_ty = image_ty else {
                return
            }
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: _image_ty)
            } completionHandler: { (result_ty, error_ty) in
                DispatchQueue.main.async {
                    if result_ty {
                        kWindow_ty.toast_ty("保存成功")
                    } else {
                        kWindow_ty.toast_ty("保存失败")
                        print("保存照片失败")
                    }
                }
            }
        }.show_ty()
        
    }
    
    public func scrolling_ty(reduce_ty scale_ty: Float) {
        self.backgroundView_ty.layer.opacity = scale_ty
    }
}
