//
//  TYNetworkAuthManager.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation

/// 网络授权管理
class TYNetworkAuthManager_ty: NSObject {
    
    static let `default` = TYNetworkAuthManager_ty()
    
    var state: TYNetworkAccessibleState_ty?
    
    
    private override init() {
        super.init()
        self.check()
        /// 网络授权变化
        NotificationCenter.default.addObserver(self, selector: #selector(networkChange(_:)), name: Notification.Name.TYNetworkAccessibityChanged, object: nil)
    }
    
    func check() {
        TYNetworkAccessibity_ty.start()
        TYNetworkAccessibity_ty.setAlertEnable(true)
    }
    
    @objc func networkChange(_ notification: Notification) {
        print("网络权限发生了变化：\(TYNetworkAccessibity_ty.currentState().rawValue)")
        self.state = TYNetworkAccessibity_ty.currentState()
    }
}
