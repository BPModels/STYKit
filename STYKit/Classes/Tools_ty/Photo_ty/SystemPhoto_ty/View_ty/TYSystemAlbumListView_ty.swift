//
//  TYSystemAlbumListView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Photos
import UIKit

public protocol TYSystemAlbumListViewDelegate_ty: NSObjectProtocol {
    func selectedAlbum_ty(model_ty: TYPhotoAlbumModel_ty?)
    func showAlbumAction_ty()
    func hideAlbumAction_ty()
}

public class TYSystemAlbumListView_ty: TYView_ty, UITableViewDelegate, UITableViewDataSource {

    private let cellID_ty = "kBPSystemAlbumCell_ty"
    private var albumList_ty: [TYPhotoAlbumModel_ty] = []
    private var currentModel_ty: TYPhotoAlbumModel_ty? {
        didSet {
            self.delegate_ty?.selectedAlbum_ty(model_ty: currentModel_ty)
            self.tableView_ty.reloadData()
        }
    }
    private var tableViewHeight_ty = CGFloat.zero
    private let cellHeight_ty      = AdaptSize_ty(56)
    private let tableViewMaxH_ty   = AdaptSize_ty(600)

    weak var delegate_ty: TYSystemAlbumListViewDelegate_ty?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tableView_ty: TYTableView_ty = {
        let tableView_ty = TYTableView_ty()
        tableView_ty.showsHorizontalScrollIndicator = false
        tableView_ty.showsVerticalScrollIndicator   = false
        return tableView_ty
    }()

    private var backgroundView_ty: UIView = {
        let view_ty = UIView()
        view_ty.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view_ty.isUserInteractionEnabled = true
        return view_ty
    }()

    public override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(backgroundView_ty)
        self.addSubview(tableView_ty)
        backgroundView_ty.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.layer.masksToBounds  = true
        self.tableView_ty.register(TYSystemAlbumCell_ty.classForCoder(), forCellReuseIdentifier: cellID_ty)
        self.tableView_ty.delegate   = self
        self.tableView_ty.dataSource = self
        let tapAction_ty = UITapGestureRecognizer(target: self, action: #selector(hideView_ty))
        self.backgroundView_ty.addGestureRecognizer(tapAction_ty)
    }

    // MARK: ==== Event ====

    public func setData_ty(albumList_ty: [TYPhotoAlbumModel_ty], current_ty model_ty: TYPhotoAlbumModel_ty?) {
        self.albumList_ty    = albumList_ty
        self.currentModel_ty = model_ty
        tableViewHeight_ty   = CGFloat(albumList_ty.count) * cellHeight_ty
        tableViewHeight_ty   = tableViewHeight_ty > tableViewMaxH_ty ? tableViewMaxH_ty : tableViewHeight_ty
        tableView_ty.snp.remakeConstraints { (make) in
            make.center.width.equalToSuperview()
            make.bottom.equalTo(backgroundView_ty.snp.top)
            make.height.equalTo(tableViewHeight_ty)
        }
    }

    public func showView_ty() {
        self.isHidden = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.tableView_ty.transform = CGAffineTransform(translationX: 0, y: self.tableViewHeight_ty)
        } completion: { [weak self] finished_ty in
            guard let self = self else { return }
            self.delegate_ty?.showAlbumAction_ty()
        }
    }

    @objc
    public func hideView_ty() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.tableView_ty.transform = .identity
        } completion: { [weak self] (finished_ty) in
            guard let self = self else { return }
            if finished_ty {
                self.isHidden = true
                self.delegate_ty?.hideAlbumAction_ty()
            }
        }
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumList_ty.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell_ty = tableView.dequeueReusableCell(withIdentifier: cellID_ty, for: indexPath) as? TYSystemAlbumCell_ty else {
            return UITableViewCell()
        }
        let model_ty = self.albumList_ty[indexPath.row]
        let selected_ty: Bool = {
            guard let _currentModel_ty = self.currentModel_ty else { return false }
            return _currentModel_ty.id_ty == model_ty.id_ty
        }()
        cell_ty.setData_ty(model_ty: model_ty, isCurrent_ty: selected_ty)
        return cell_ty
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentModel_ty = self.albumList_ty[indexPath.row]
        self.hideView_ty()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight_ty
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

