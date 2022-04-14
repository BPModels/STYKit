//
//  TYSystemAlbumListView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Photos
import UIKit

public protocol TYSystemAlbumListViewDelegate_ty: NSObjectProtocol {
    func selectedAlbum_ty(model: TYPhotoAlbumModel_ty?)
    func showAlbumAction_ty()
    func hideAlbumAction_ty()
}

public class TYSystemAlbumListView_ty: TYView_ty, UITableViewDelegate, UITableViewDataSource {

    private let cellID_ty = "kBPSystemAlbumCell"
    private var albumList_ty: [TYPhotoAlbumModel_ty] = []
    private var currentModel_ty: TYPhotoAlbumModel_ty? {
        didSet {
            self.delegate_ty?.selectedAlbum_ty(model: currentModel_ty)
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
        let tableView = TYTableView_ty()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator   = false
        return tableView
    }()

    private var backgroundView_ty: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.isUserInteractionEnabled = true
        return view
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
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(hideView_ty))
        self.backgroundView_ty.addGestureRecognizer(tapAction)
    }

    // MARK: ==== Event ====

    public func setData_ty(albumList: [TYPhotoAlbumModel_ty], current model: TYPhotoAlbumModel_ty?) {
        self.albumList_ty    = albumList
        self.currentModel_ty = model
        tableViewHeight_ty   = CGFloat(albumList.count) * cellHeight_ty
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
        } completion: { [weak self] finished in
            guard let self = self else { return }
            self.delegate_ty?.showAlbumAction_ty()
        }
    }

    @objc
    public func hideView_ty() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.tableView_ty.transform = .identity
        } completion: { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID_ty, for: indexPath) as? TYSystemAlbumCell_ty else {
            return UITableViewCell()
        }
        let model = self.albumList_ty[indexPath.row]
        let selected: Bool = {
            guard let _currentModel = self.currentModel_ty else { return false }
            return _currentModel.id_ty == model.id_ty
        }()
        cell.setData_ty(model: model, isCurrent: selected)
        return cell
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

