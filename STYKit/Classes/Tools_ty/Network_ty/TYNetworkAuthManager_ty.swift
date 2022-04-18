//
//  TYNetworkAuthManager.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation

/// 网络授权管理
class TYNetworkAuthManager_ty: NSObject {
    
    static let share_ty = TYNetworkAuthManager_ty()
    
    var state_ty: TYNetworkAccessibleState_ty?
    
    
    private override init() {
        super.init()
        self.check_ty()
        /// 网络授权变化
        NotificationCenter.default.addObserver(self, selector: #selector(networkChange_ty(_:)), name: Notification.Name.TYNetworkAccessibityChanged_ty, object: nil)
    }
    
    func check_ty() {
        TYNetworkAccessibity_ty.start()
        TYNetworkAccessibity_ty.setAlertEnable(true)
    }
    
    @objc func networkChange_ty(_ notification_ty: Notification) {
        print("网络权限发生了变化：\(TYNetworkAccessibity_ty.currentState_ty().rawValue)")
        self.state_ty = TYNetworkAccessibity_ty.currentState_ty()
    }
}
