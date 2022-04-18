//
//  TYRequest_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation

public enum TYHTTPMethod_ty: String {
    case options_ty = "OPTIONS"
    case get_ty     = "GET"
    case head_ty    = "HEAD"
    case post_ty    = "POST"
    case put_ty     = "PUT"
    case patch_ty   = "PATCH"
    case delete_ty  = "DELETE"
}

/// 请求对象，具体业务类可以实现具体值
public protocol TYRequest_ty {
    
    // TODO: ==== 必须实现 ====
    /// 请求方法类型
    var method_ty: TYHTTPMethod_ty { get }
    
    /// 请求POST参数
    var parameters_ty: [String : Any?]? { get }
    
    /// 路由地址
    var path_ty: String { get }
    
    // TODO: ==== 可选实现 ====
    
    /// 请求头（默认实现，可自定义）
    var header_ty: [String : String] { get }
    
    /// 域名地址（默认实现，如有多域名，则子类自己实现即可）
    var url_ty: URL? { get }
    
    /// 是否加密
    var isEncrypt: Bool { get }
}

/// 默认实现
public extension TYRequest_ty {

    var header_ty: [String : String] {
        var _header_ty: [String: String] = [
                        "Content-Type"   : "application/json",
                        "Connection"     : "keep-alive",
                        "TY-CHANNEL-ID"  : "AppStore",
                        "TY-TIMESTAMP"   : "\(Date().timeIntervalSince1970)"
        ]
        // 增加自定义Header参数
        let otherHeader_ty = TYNetworkConfig_ty.share_ty.headerParameters_ty
        otherHeader_ty.forEach { (key_ty: String, value_ty: String) in
            _header_ty[key_ty] = value_ty
        }
        return _header_ty
    }

    var parameters_ty: [String : Any?]? {
        return nil
    }

    var method_ty: TYHTTPMethod_ty {
        return .get_ty
    }

    var url_ty: URL? {
        let urlStr_ty = TYNetworkConfig_ty.share_ty.domainApi_ty + path_ty
        if urlStr_ty.isEmpty {
            print("请配置域名：TYNetworkConfig_ty.share_ty.domainApi_ty")
        }
        guard let _urlStr_ty = urlStr_ty.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let _url_ty = URL(string: _urlStr_ty) else {
            return nil
        }
        return _url_ty
    }

    var path_ty: String { return "" }
    
    /// 是否加密
    var isEncrypt: Bool { return false }
}

