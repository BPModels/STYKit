//
//  TYNetworkGlobal_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation
import Alamofire
import CoreTelephony

/// 上传文件Key
//public let kUploadFilesKey = "uploadFileKey"

/// 是否有网络权限
public var isNetworkAuth_ty: Bool {
    let status_ty = TYNetworkAuthManager_ty.share_ty.state_ty
    return status_ty != .restricted_ty
}

/// 是否有网络
public var isReachable_ty: Bool {
    get {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

/// 是否是蜂窝网络,WWAN网络
/// WWAN（Wireless Wide Area Network，无线广域网）
public var isReachableOnWWAN_ty: Bool {
    get {
        return NetworkReachabilityManager()?.isReachableOnCellular ?? false
    }
}

/// 是否是Wi-Fi或者以太网网络
public var isReachableOnEthernetOrWiFi_ty: Bool {
    get {
        return NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi ?? false
    }
}

/// 获得网络类型描述
public var networkType_ty: String {
    get {
        if isReachableOnWWAN_ty {
            let info_ty = CTTelephonyNetworkInfo()
            if let currentRadioAccessTechnology_ty = info_ty.currentRadioAccessTechnology {
                if #available(iOS 14.1, *) {
                    if currentRadioAccessTechnology_ty == CTRadioAccessTechnologyNR || currentRadioAccessTechnology_ty == CTRadioAccessTechnologyNRNSA {
                        return "5G"
                    }
                }
                switch currentRadioAccessTechnology_ty {
                case CTRadioAccessTechnologyGPRS,
                     CTRadioAccessTechnologyCDMA1x:
                    return "2G"
                case CTRadioAccessTechnologyEdge:
                    return "2.5G"
                case CTRadioAccessTechnologyWCDMA,
                     CTRadioAccessTechnologyHSUPA,
                     CTRadioAccessTechnologyCDMAEVDORev0,
                     CTRadioAccessTechnologyCDMAEVDORevA,
                     CTRadioAccessTechnologyCDMAEVDORevB:
                    return "3G"
                case CTRadioAccessTechnologyHSDPA,
                     CTRadioAccessTechnologyeHRPD:
                    return "3.5G"
                case CTRadioAccessTechnologyLTE:
                    return "4G"
                default:
                    return "Unknown G"
                }
            }

        } else if isReachableOnEthernetOrWiFi_ty {
            return "WiFi"
        }
        return "Unknown"
    }
}
