//
//  TYStringTransform_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import ObjectMapper

public class TYStringTransform_ty: TransformType {

    public typealias Object = String
    
    public typealias JSON = Any?
    
    public init() {}
        
    public func transformFromJSON(_ value: Any?) -> String? {
        var result_ty: String?
        guard let json_ty = value else {
            return result_ty
        }
        if json_ty is String {
            result_ty = json_ty as? String
        } else if json_ty is Int {
            result_ty = "\(json_ty)"
        }
        return result_ty
    }
    
    public func transformToJSON(_ value: String?) -> Any?? {
        guard let _value_ty = value else {
            return nil
        }
        return _value_ty
    }
}

