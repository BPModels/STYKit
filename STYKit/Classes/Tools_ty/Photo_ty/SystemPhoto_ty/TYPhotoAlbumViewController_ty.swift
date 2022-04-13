//
//  TYPhotoAlbumViewController_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Foundation

public protocol TYPhotoAlbumViewControllerDelegate_ty: TYPhotoAlbumToolsDelegate_ty {}

/// 方格显示传递过来的资源
public class TYPhotoAlbumViewController_ty:
    TYViewController_ty,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    TYPhotoAlbumToolsDelegate_ty,
    TYPhotoAlbumCellDelegate_ty {
    
    public weak var delegate_ty: TYPhotoAlbumViewControllerDelegate_ty?
    
    var isSelect_ty: Bool = false {
        willSet {
            if newValue {
                self.customNavigationBar_ty?.setRightTitle_ty(text: "取消")
                self.showToolsView()
            } else {
                self.customNavigationBar_ty?.setRightTitle_ty(text: "选择")
                self.hideToolsView()
            }
            self.selectedList_ty.removeAll()
            self.collectionView_ty.reloadData()
        }
    }

    let kTYPhotoAlbumCellID_ty = "kTYPhotoAlbumCell"
    /// 总资源
    public var modelList_ty: [TYMediaModel_ty] = []
    /// 已选资源
    var selectedList_ty: [TYMediaModel_ty] = []

    private var collectionView_ty: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width  = kScreenWidth_ty / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing      = .zero
        layout.minimumInteritemSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        return collectionView
    }()

    private var toolsView_ty = TYPhotoAlbumToolsView_ty()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.collectionView_ty.reloadData()
    }

    public override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(collectionView_ty)
        self.view.addSubview(toolsView_ty)
        collectionView_ty.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight_ty)
        }
        toolsView_ty.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kScreenHeight_ty)
            make.height.equalTo(AdaptSize_ty(50) + kSafeBottomMargin_ty)
        }
    }

    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title = "图片和视频"
        self.customNavigationBar_ty?.setRightTitle_ty(text: "选择")
        self.toolsView_ty.delegate_ty     = self
        self.collectionView_ty.delegate   = self
        self.collectionView_ty.dataSource = self
        self.collectionView_ty.register(TYMediaCell_ty.classForCoder(), forCellWithReuseIdentifier: self.kTYPhotoAlbumCellID_ty)
    }

    // MARK: ==== Event ====
    private func showToolsView() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.toolsView_ty.transform = CGAffineTransform(translationX: 0, y: -self.toolsView_ty.height_ty)
        }
    }

    private func hideToolsView() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.toolsView_ty.transform = .identity
        }
    }

    // MARK: ==== TYPhotoAlbumToolsDelegate_ty ====
    public func clickShareAction_ty() {
        print("clickShareAction")
        self.delegate_ty?.clickShareAction_ty()
    }

    public func clickSaveAction_ty() {
        print("clickSaveAction")
        self.delegate_ty?.clickSaveAction_ty()
    }

    public func clickDeleteAction_ty() {
        print("clickDeleteAction")
        self.delegate_ty?.clickDeleteAction_ty()
    }

    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelList_ty.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTYPhotoAlbumCellID_ty, for: indexPath) as? TYMediaCell_ty else {
            return TYCollectionViewCell_ty()
        }
        let model     = self.modelList_ty[indexPath.row]
        let selected  = self.selectedList_ty.contains(model)
        cell.delegate_ty = self
        cell.setData_ty(model: model, hideSelect: !self.isSelect_ty, isSelected: selected)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TYMediaCell_ty else {
            return
        }
        TYBrowserView_ty(type: .custom_ty(modelList: modelList_ty), current: indexPath.row).show_ty(animationView: cell.imageView_ty)
    }

    // MARK: ==== TYPhotoAlbumCellDelegate_ty ====
    func selectedImage_ty(model: Any) {
        guard let _model = model as? TYMediaModel_ty, !self.selectedList_ty.contains(_model) else { return }
        self.selectedList_ty.append(_model)
        self.collectionView_ty.reloadData()
    }

    func unselectImage_ty(model: Any) {
        guard let _model = model as? TYMediaModel_ty, let index = self.selectedList_ty.firstIndex(of: _model) else { return }
        self.selectedList_ty.remove(at: index)
        self.collectionView_ty.reloadData()
    }
    
    func selectedExcess_ty() {}
    
    // MARK: ==== TYNavigationBarDelegate_ty ====
    public override func rightAction_ty() {
        super.rightAction_ty()
        self.isSelect_ty = !self.isSelect_ty
    }
}
