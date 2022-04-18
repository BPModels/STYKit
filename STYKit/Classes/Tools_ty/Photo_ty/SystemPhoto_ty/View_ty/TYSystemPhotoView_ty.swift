//
//  TYSystemPhotoView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//


import Photos
import UIKit

public protocol TYSystemPhotoViewDelegate_ty: NSObjectProtocol {
    func clickImage_ty(indexPath_ty: IndexPath, from_ty imageView_ty: UIImageView?)
    func selectedImage_ty()
    func unselectImage_ty()
}

public class TYSystemPhotoView_ty: TYView_ty, UICollectionViewDelegate, UICollectionViewDataSource, TYPhotoAlbumCellDelegate_ty {
    
    weak var delegate_ty: TYSystemPhotoViewDelegate_ty?
    private let kBPPhotoAlbumCellID_ty = "kBPPhotoAlbumCell_ty"
    /// 当前相册对象
    private var albumModel_ty: TYPhotoAlbumModel_ty?
    /// 已选中的资源
    private var selectedList_ty: [PHAsset] = []
    /// 最大选择数量
    var maxSelectCount_ty: Int = 1
    
    /// 照片列表
    private var collectionView_ty: UICollectionView = {
        let layout_ty = UICollectionViewFlowLayout()
        let width_ty  = kScreenWidth_ty / 4
        layout_ty.itemSize = CGSize(width: width_ty, height: width_ty)
        layout_ty.minimumLineSpacing      = .zero
        layout_ty.minimumInteritemSpacing = .zero
        let collectionView_ty = UICollectionView(frame: .zero, collectionViewLayout: layout_ty)
        collectionView_ty.showsHorizontalScrollIndicator = false
        collectionView_ty.showsVerticalScrollIndicator   = false
        collectionView_ty.backgroundColor = .white
        return collectionView_ty
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(collectionView_ty)
        collectionView_ty.snp.makeConstraints { (make_ty) in
            make_ty.edges.equalToSuperview()
        }
    }
    
    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.collectionView_ty.delegate   = self
        self.collectionView_ty.dataSource = self
        self.collectionView_ty.register(TYMediaCell_ty.classForCoder(), forCellWithReuseIdentifier: self.kBPPhotoAlbumCellID_ty)
    }
    
    // MARK: ==== Event ====
    
    public func reload_ty(album_ty model_ty: TYPhotoAlbumModel_ty?) {
        self.albumModel_ty = model_ty
        self.collectionView_ty.reloadData()
    }
    
    /// 获取已选择照片列表
    public func selectedPhotoList() -> [PHAsset] {
        return self.selectedList_ty
    }
    
    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumModel_ty?.assets_ty.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell_ty = collectionView.dequeueReusableCell(withReuseIdentifier: kBPPhotoAlbumCellID_ty, for: indexPath) as? TYMediaCell_ty, let asset_ty = self.albumModel_ty?.assets_ty[indexPath.row] else {
            return TYCollectionViewCell_ty()
        }
        let selected_ty    = self.selectedList_ty.contains(asset_ty)
        let selectedMax_ty = self.selectedList_ty.count >= maxSelectCount_ty
        cell_ty.setData_ty(asset_ty: asset_ty, isSelected_ty: selected_ty, selectedMax_ty: selectedMax_ty)
        cell_ty.delegate_ty = self
        return cell_ty
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell_ty = collectionView.cellForItem(at: indexPath) as? TYMediaCell_ty else {
            return
        }
        self.delegate_ty?.clickImage_ty(indexPath_ty: indexPath, from_ty: cell_ty.imageView_ty)
    }
    
    
    // MARK: ==== TYPhotoAlbumCellDelegate_ty ====
    public func selectedImage_ty(model_ty: Any) {
        guard let _model_ty = model_ty as? PHAsset,
              !self.selectedList_ty.contains(_model_ty),
              self.selectedList_ty.count < maxSelectCount_ty else {
                  return
              }
        self.selectedList_ty.append(_model_ty)
        self.collectionView_ty.reloadData()
        self.delegate_ty?.selectedImage_ty()
    }

    public func unselectImage_ty(model_ty: Any) {
        guard let _model_ty = model_ty as? PHAsset, let index_ty = self.selectedList_ty.firstIndex(of: _model_ty) else { return }
        self.selectedList_ty.remove(at: index_ty)
        self.collectionView_ty.reloadData()
        self.delegate_ty?.unselectImage_ty()
    }
    
    public func selectedExcess_ty() {
        kWindow_ty.toast_ty("您最多可以上传\(maxSelectCount_ty)张图片")
    }
}


