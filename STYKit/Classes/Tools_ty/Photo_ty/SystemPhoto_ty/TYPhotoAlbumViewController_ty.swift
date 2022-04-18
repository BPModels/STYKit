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
                self.customNavigationBar_ty?.setRightTitle_ty(text_ty: "取消")
                self.showToolsView()
            } else {
                self.customNavigationBar_ty?.setRightTitle_ty(text_ty: "选择")
                self.hideToolsView()
            }
            self.selectedList_ty.removeAll()
            self.collectionView_ty.reloadData()
        }
    }

    let kTYPhotoAlbumCellID_ty = "kTYPhotoAlbumCell_ty"
    /// 总资源
    public var modelList_ty: [TYMediaModel_ty] = []
    /// 已选资源
    var selectedList_ty: [TYMediaModel_ty] = []

    private var collectionView_ty: UICollectionView = {
        let layout_ty = UICollectionViewFlowLayout()
        let width_ty  = kScreenWidth_ty / 4
        layout_ty.itemSize = CGSize(width: width_ty, height: width_ty)
        layout_ty.minimumLineSpacing      = .zero
        layout_ty.minimumInteritemSpacing = .zero
        let collectionView_ty = UICollectionView(frame: .zero, collectionViewLayout: layout_ty)
        collectionView_ty.showsHorizontalScrollIndicator = false
        collectionView_ty.showsVerticalScrollIndicator   = false
        return collectionView_ty
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
        collectionView_ty.snp.makeConstraints { (make_ty) in
            make_ty.left.right.bottom.equalToSuperview()
            make_ty.top.equalToSuperview().offset(kNavigationHeight_ty)
        }
        toolsView_ty.snp.makeConstraints { (make_ty) in
            make_ty.left.right.equalToSuperview()
            make_ty.top.equalToSuperview().offset(kScreenHeight_ty)
            make_ty.height.equalTo(AdaptSize_ty(50) + kSafeBottomMargin_ty)
        }
    }

    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.customNavigationBar_ty?.title_ty = "图片和视频"
        self.customNavigationBar_ty?.setRightTitle_ty(text_ty: "选择")
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
        guard let cell_ty = collectionView.dequeueReusableCell(withReuseIdentifier: kTYPhotoAlbumCellID_ty, for: indexPath) as? TYMediaCell_ty else {
            return TYCollectionViewCell_ty()
        }
        let model_ty     = self.modelList_ty[indexPath.row]
        let selected_ty  = self.selectedList_ty.contains(model_ty)
        cell_ty.delegate_ty = self
        cell_ty.setData_ty(model_ty: model_ty, hideSelect_ty: !self.isSelect_ty, isSelected_ty: selected_ty)
        return cell_ty
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell_ty = collectionView.cellForItem(at: indexPath) as? TYMediaCell_ty else {
            return
        }
        TYBrowserView_ty(type_ty: .custom_ty(modelList_ty: modelList_ty), current_ty: indexPath.row).show_ty(animationView_ty: cell_ty.imageView_ty)
    }

    // MARK: ==== TYPhotoAlbumCellDelegate_ty ====
    public func selectedImage_ty(model_ty: Any) {
        guard let _model_ty = model_ty as? TYMediaModel_ty, !self.selectedList_ty.contains(_model_ty) else { return }
        self.selectedList_ty.append(_model_ty)
        self.collectionView_ty.reloadData()
    }

    public func unselectImage_ty(model_ty: Any) {
        guard let _model_ty = model_ty as? TYMediaModel_ty, let index_ty = self.selectedList_ty.firstIndex(of: _model_ty) else { return }
        self.selectedList_ty.remove(at: index_ty)
        self.collectionView_ty.reloadData()
    }
    
    public func selectedExcess_ty() {}
    
    // MARK: ==== TYNavigationBarDelegate_ty ====
    public override func rightAction_ty() {
        super.rightAction_ty()
        self.isSelect_ty = !self.isSelect_ty
    }
}
