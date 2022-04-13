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
    case custom_ty(modelList: [TYMediaModel_ty])
    /// 系统相册
    case system_ty(result: [PHAsset])
}

public protocol TYImageBrowserDelegate_ty: NSObjectProtocol {
    func reuploadImage(model:[TYMediaModel_ty])
}

public class TYBrowserView_ty:
    TYView_ty,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    TYBrowserImageCellDelegate_ty,
    TYBrowserVideoCellDelegate_ty {
    
    public weak var delegate_ty:TYImageBrowserDelegate_ty?
    
    private let kTYBrowserImageCell_tyID_ty = "kTYBrowserImageCell_tyID"
    private let kTYBrowserVideoCell_tyID_ty = "kTYBrowserVideoCell_tyID"
    private var medioModelList_ty: [TYMediaModel_ty] = []
    private var assetModelList_ty: PHFetchResult<PHAsset>?
    private var type_ty: TYImageBrowserType_ty
    private var currentIndex_ty: Int
    private var startFrame_ty: CGRect?
    
    var collectionView_ty: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize           = kWindow_ty.size_ty
        layout.scrollDirection    = .horizontal
        layout.minimumLineSpacing = .zero
//        layout.minimumInteritemSpacing = AdaptSize_ty(20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.isPagingEnabled  = true
        collectionView.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleWidth, .flexibleHeight)
        collectionView.backgroundColor  = .clear
        collectionView.isHidden         = true
        return collectionView
    }()
    
    
    private var backgroundView_ty: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    private var albumButton_ty: TYButton_ty = {
        let button = TYButton_ty()
        button.setTitle("全部", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font   = UIFont.custom_ty(.PingFangTCRegular, size: AdaptSize_ty(14))
        button.backgroundColor    = UIColor.black0_ty.withAlphaComponent(0.9)
        button.layer.cornerRadius = AdaptSize_ty(5)
        button.isHidden           = true
        return button
    }()
    
    public init(type: TYImageBrowserType_ty, current index: Int) {
        self.type_ty         = type
        self.currentIndex_ty = index
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
        backgroundView_ty.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView_ty.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        albumButton_ty.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize_ty(40))
            make.right.equalToSuperview().offset(-AdaptSize_ty(20))
            make.size.equalTo(CGSize(width: AdaptSize_ty(40), height: AdaptSize_ty(25)))
        }
    }
    
    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.collectionView_ty.delegate   = self
        self.collectionView_ty.dataSource = self
        self.collectionView_ty.register(TYBrowserImageCell_ty.classForCoder(), forCellWithReuseIdentifier: kTYBrowserImageCell_tyID_ty)
        self.collectionView_ty.register(TYBrowserVideoCell_ty.classForCoder(), forCellWithReuseIdentifier: kTYBrowserVideoCell_tyID_ty)
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
    private func showAnimation_ty(startView: UIImageView) {
        self.startFrame_ty = startView.convert(startView.bounds, to: kWindow_ty)
        // 做动画的视图
        let imageView = UIImageView()
        imageView.frame       = startFrame_ty ?? CGRect(origin: .zero, size: kWindow_ty.size_ty)
        imageView.image       = startView.image
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        self.collectionView_ty.isHidden = true
        UIView.animate(withDuration: 0.25) {
            imageView.frame = CGRect(origin: .zero, size: kWindow_ty.size_ty)
        } completion: { [weak self] (finished) in
            if (finished) {
                imageView.removeFromSuperview()
                self?.collectionView_ty.isHidden = false
            }
        }
    }
    
    private func hideAnimation_ty(view: UIView) {
        guard let startFrame = self.startFrame_ty else {
            self.hide_ty()
            return
        }
        let imageView = UIImageView()
        imageView.frame       = view.frame
        imageView.image       = view.toImage_ty()
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        self.collectionView_ty.isHidden = true
        UIView.animate(withDuration: 0.25) { [weak self] in
            imageView.frame = startFrame
            self?.backgroundView_ty.layer.opacity = 0.0
        } completion: { [weak self] (finished) in
            guard let self = self else { return }
            if (finished) {
                imageView.removeFromSuperview()
                self.layer.opacity = 0.0
                self.hide_ty()
            }
        }
    }
    
    // MARK: ==== Event ====
    
    /// 显示入场动画
    /// - Parameter animationView: 动画参考对象
    public func show_ty(animationView: UIImageView?) {
        kWindow_ty.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        guard let imageView = animationView else {
            return
        }
        // 显示进入动画
        self.showAnimation_ty(startView: imageView)
    }
    
    @objc
    public func hide_ty() {
        self.removeFromSuperview()
    }
    
    @objc
    private func showAlubmVC_ty() {
        let vc = TYPhotoAlbumViewController_ty()
        vc.modelList_ty = self.medioModelList_ty
        currentNVC_ty?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: ==== Tools ====
    private func scrollToCurrentPage_ty() {
        let offsetX = kWindow_ty.width_ty * CGFloat(self.currentIndex_ty)
        self.collectionView_ty.contentOffset = CGPoint(x: offsetX, y: 0)
    }
    
    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type_ty {
        case .custom_ty(let modelList):
            return modelList.count
        case .system_ty(let result):
            return result.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch type_ty {
        case .custom_ty(let modelList):
            let model = modelList[indexPath.row]
            switch model.type_ty {
            case .image_ty:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTYBrowserImageCell_tyID_ty, for: indexPath) as? TYBrowserImageCell_ty, let imageModel = model as? TYMediaImageModel_ty else {
                    return TYCollectionViewCell_ty()
                }
                cell.delegate_ty = self
                cell.setCustomData_ty(model: imageModel, userId: "")
                return cell
            case .video_ty:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTYBrowserVideoCell_tyID_ty, for: indexPath) as? TYBrowserVideoCell_ty, let videoModel = model as? TYMediaVideoModel_ty else {
                    return TYCollectionViewCell_ty()
                }
                cell.setData_ty(model: videoModel)
                cell.delegate_ty = self
                return cell
            default:
                return TYBrowserImageCell_ty()
            }
        case .system_ty(let result):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTYBrowserImageCell_tyID_ty, for: indexPath) as? TYBrowserImageCell_ty else {
                return TYCollectionViewCell_ty()
            }
            cell.delegate_ty = self
            let asset: PHAsset = result[indexPath.row]
            cell.setSystemData_ty(asset: asset)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? TYBrowserImageCell_ty)?.updateZoomScale_ty()
    }
    
    // 滑动结束通知Cell
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
    // MARK: ==== TYBrowserVideoCell_tyDelegate ====
    func videoViewClosedAction_ty(view: UIView) {
        if self.startFrame_ty != nil {
            self.hideAnimation_ty(view: view)
        } else {
            self.hide_ty()
        }
    }
    
    func videoViewLongPressAction_ty(model: TYMediaVideoModel_ty?) {
        print("保存视频暂未适配")
    }
    
    @objc private func savedVideoFinished_ty() {
        print("保存成功")
    }
    
    public func closeAction_ty(view: UIView) {
        if self.startFrame_ty != nil {
            self.hideAnimation_ty(view: view)
        } else {
            self.hide_ty()
        }
    }
    
    // MARK: ==== TYImageBrowserCellDelegate ====
    public func clickAction_ty(view: UIView) {
        if self.startFrame_ty != nil {
            self.hideAnimation_ty(view: view)
        } else {
            self.hide_ty()
        }
    }
    
    public func longPressAction_ty(image: UIImage?) {
        TYActionSheet_ty().addItem_ty(title: "保存") {
            guard let image = image else {
                return
            }
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { (result, error) in
                DispatchQueue.main.async {
                    if result {
                        kWindow_ty.toast_ty("保存成功")
                    } else {
                        kWindow_ty.toast_ty("保存失败")
                        print("保存照片失败")
                    }
                }
            }
        }.show_ty()
        
    }
    
    public func scrolling_ty(reduce scale: Float) {
        self.backgroundView_ty.layer.opacity = scale
    }
}
