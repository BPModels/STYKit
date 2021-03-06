//
//  TYNetworkConfig.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation
import Alamofire

public struct TYNetworkConfig_ty {
    
    public static var share_ty = TYNetworkConfig_ty()
    
    /// 域名
    public var domainApi_ty: String = ""

    /// Web域名
    public var demainWebApi_ty: String = ""
    
    /// 额外添加的Header参数
    public var headerParameters_ty: [String: String] = [:]
    
    /// 更新Header，如果没有则会添加到header
    /// - Parameter parameters: header参数
    public mutating func updateHeader_ty(parameters_ty: [String: String]) {
        self.headerParameters_ty = parameters_ty
    }
    
    /// 开启网络状态监听
    public func startNetworkListener_ty(update_ty: ((NetworkReachabilityManager.NetworkReachabilityStatus) ->Void)?) {
        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { (status_ty: NetworkReachabilityManager.NetworkReachabilityStatus) in
            update_ty?(status_ty)
        })
    }
    
    /// 关闭网络监听
    public func stopNetworkListener_ty() {
        NetworkReachabilityManager.default?.stopListening()
    }
    
}
