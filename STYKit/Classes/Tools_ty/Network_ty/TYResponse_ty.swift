//
//  TYBaseResponse_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation
import ObjectMapper

public protocol TYResopnse_ty: Mappable {
    /// 状态码
    var statusCode_ty: Int { get }
    /// 状态消息
    var statusMessage_ty: String? { get }
    /// 警告消息
    var warningDesc_ty: String? { get }
    /// 返回对象
    var response_ty: URLResponse? { set get }
    /// 请求对象
    var request_ty: URLRequest? { set get }
}

/// 数据为空时使用
public struct TYResponseNil_ty: TYResopnse_ty {
    public var statusCode_ty: Int = 0
    public var statusMessage_ty: String?
    public var warningDesc_ty: String?
    public var response_ty: URLResponse?
    public var request_ty: URLRequest?
    
    /// 根据类型返回具体对象
    public var data_ty:Any?
    /// 返回后台完整Data数据
    public var json_ty: Any?
    
    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        statusCode_ty    <- map["code"]
        statusMessage_ty <- map["msg"]
        warningDesc_ty   <- map["warning"]
        data_ty          <- map["retObj"]
        json_ty          <- map["retObj"]
    }
}
/// 返回对象时使用
public struct TYResponse_ty<T: Mappable> : TYResopnse_ty {
    
    public var response_ty: URLResponse?
    public var request_ty: URLRequest?

    private var status_ty: Int = 0
    private var message_ty: String?
    private var warning_ty: String?

    /// 根据类型返回具体对象
    public var data_ty:T?
    /// 返回后台完整Data数据
    public var json_ty: Any?

    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        message_ty   <- map["msg"]
        warning_ty   <- map["warning"]
        data_ty      <- map["retObj"]
        status_ty    <- map["code"]
        json_ty      <- map["retObj"]
    }
}

extension TYResponse_ty {
    public var statusCode_ty: Int {
        return status_ty
    }

    public var statusMessage_ty: String? {
        return message_ty
    }

    public var warningDesc_ty: String? {
        return warning_ty
    }
}

/// 返回列表时使用
public struct TYResponseArray_ty<T: Mappable> : TYResopnse_ty {

    public var response_ty: URLResponse?
    public var request_ty: URLRequest?

    private var status_ty: Int = 0
    private var message_ty: String?
    private var warning_ty: String?

    public var dataArray_ty:[T]?
    public var json_ty:Any?

    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        status_ty    <- map["code"]
        message_ty   <- map["msg"]
        warning_ty   <- map["warning"]
        dataArray_ty <- map["retObj"]
        json_ty      <- map["retObj"]
    }
}

extension TYResponseArray_ty {

    public var statusCode_ty: Int {
        return status_ty
    }

    public var statusMessage_ty: String? {
        return message_ty
    }

    public var warningDesc_ty: String? {
        return warning_ty
    }
}
