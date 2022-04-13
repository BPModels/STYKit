//
//  TYSystemPhotoView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//


import Photos
import UIKit

protocol TYSystemPhotoViewDelegate_ty: NSObjectProtocol {
    func clickImage_ty(indexPath: IndexPath, from imageView: UIImageView?)
    func selectedImage_ty()
    func unselectImage_ty()
}

class TYSystemPhotoView_ty: TYView_ty, UICollectionViewDelegate, UICollectionViewDataSource, TYPhotoAlbumCellDelegate_ty {
    
    weak var delegate_ty: TYSystemPhotoViewDelegate_ty?
    private let kBPPhotoAlbumCellID_ty = "kBPPhotoAlbumCell"
    /// 当前相册对象
    private var albumModel_ty: TYPhotoAlbumModel_ty?
    /// 已选中的资源
    private var selectedList_ty: [PHAsset] = []
    /// 最大选择数量
    var maxSelectCount_ty: Int = 1
    
    /// 照片列表
    private var collectionView_ty: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width  = kScreenWidth_ty / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing      = .zero
        layout.minimumInteritemSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(collectionView_ty)
        collectionView_ty.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.collectionView_ty.delegate   = self
        self.collectionView_ty.dataSource = self
        self.collectionView_ty.register(TYMediaCell_ty.classForCoder(), forCellWithReuseIdentifier: self.kBPPhotoAlbumCellID_ty)
    }
    
    // MARK: ==== Event ====
    
    func reload(album model: TYPhotoAlbumModel_ty?) {
        self.albumModel_ty = model
        self.collectionView_ty.reloadData()
    }
    
    /// 获取已选择照片列表
    func selectedPhotoList() -> [PHAsset] {
        return self.selectedList_ty
    }
    
    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumModel_ty?.assets_ty.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBPPhotoAlbumCellID_ty, for: indexPath) as? TYMediaCell_ty, let asset = self.albumModel_ty?.assets_ty[indexPath.row] else {
            return TYCollectionViewCell_ty()
        }
        let selected    = self.selectedList_ty.contains(asset)
        let selectedMax = self.selectedList_ty.count >= maxSelectCount_ty
        cell.setData_ty(asset: asset, isSelected: selected, selectedMax: selectedMax)
        cell.delegate_ty = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TYMediaCell_ty else {
            return
        }
        self.delegate_ty?.clickImage_ty(indexPath: indexPath, from: cell.imageView_ty)
    }
    
    
    // MARK: ==== TYPhotoAlbumCellDelegate_ty ====
    func selectedImage_ty(model: Any) {
        guard let _model = model as? PHAsset,
              !self.selectedList_ty.contains(_model),
              self.selectedList_ty.count < maxSelectCount_ty else {
                  return
              }
        self.selectedList_ty.append(_model)
        self.collectionView_ty.reloadData()
        self.delegate_ty?.selectedImage_ty()
    }

    func unselectImage_ty(model: Any) {
        guard let _model = model as? PHAsset, let index = self.selectedList_ty.firstIndex(of: _model) else { return }
        self.selectedList_ty.remove(at: index)
        self.collectionView_ty.reloadData()
        self.delegate_ty?.unselectImage_ty()
    }
    
    func selectedExcess_ty() {
        kWindow_ty.toast_ty("您最多可以上传\(maxSelectCount_ty)张图片")
    }
}


