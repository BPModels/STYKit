//
//  ViewController.swift
//  STYKit
//
//  Created by 916878440@qq.com on 04/11/2022.
//  Copyright (c) 2022 916878440@qq.com. All rights reserved.
//

import UIKit
import STYKit

class ViewController: TYViewController_ty, UITableViewDelegate, UITableViewDataSource, BPRefreshProtocol {
    
    var count = 2

    private var tableView: TYTableView_ty = {
        let tableView = TYTableView_ty()
        tableView.estimatedRowHeight             = AdaptSize_ty(56)
        tableView.backgroundColor                = UIColor.gray0_ty
        tableView.separatorStyle                 = .none
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.view.backgroundColor = .white
    }
    
    override func createSubviews_ty() {
        super.createSubviews_ty()
        self.view.addSubview(tableView)
    }
    
    override func bindProperty_ty() {
        super.bindProperty_ty()
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.refreshDelegate = self
        
        tableView.setRefreshHeaderEnable { finishedBlock in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.count = 10
                self.tableView.reloadData()
                finishedBlock?()
                print(self.tableView.page)
            }
        }
        
        tableView.setRefreshFooterEnable { finishedBlock in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.count += 1
                self.tableView.reloadData()
                finishedBlock?()
                print(self.tableView.page)
            }
        }
    }
    
    override func updateViewConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight_ty)
        }
        super.updateViewConstraints()
    }
    
    override func bindData_ty() {
        super.bindData_ty()
        var request = TYLoginRequest_ty.sendSMS(code: "1", mobile: "17521192823")
        request     = TYLoginRequest_ty.appInit
        TYNetworkManager_ty.share_ty.request_ty(TYResponse_ty<TYHomeModel>.self, request: request) { response in
            print("Success:\(response?.data_ty)")
            
        } fail: { responseError in
            print("Fail:\n\(responseError)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .randomColor_ty()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bindData_ty()
    }

}

