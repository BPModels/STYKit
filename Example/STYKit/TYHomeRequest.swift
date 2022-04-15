//
//  TYHomeRequest.swift
//  STYKit_Example
//
//  Created by apple on 2022/4/14.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

import STYKit

enum TYLoginRequest_ty: TYRequest_ty {
    case sendSMS(code: String, mobile: String)
    case appInit
    var method_ty: TYHTTPMethod_ty {
        switch self {
        case .sendSMS:
            return .post_ty
        case .appInit:
            return .get_ty
        }
    }
    
    var parameters_ty: [String : Any?]? {
        switch self {
        case .sendSMS(let code, let mobile):
            return ["bizType":code, "mobile": mobile]
        default:
            return nil
        }
    }
    
    var path_ty: String {
        switch self {
        case .sendSMS:
            return "/api/v2/send-sms"
        case .appInit:
            return "/api/v2/config/app-init"
        }
    }
    
    var isEncrypt: Bool {
        switch self {
        case .appInit:
            return true
        default:
            return false
        }
    }
}

