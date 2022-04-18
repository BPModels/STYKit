//
//  TYIntTransform_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import ObjectMapper

public class TYIntTransform_ty: TransformType {

    public typealias Object = Int
    
    public typealias JSON = Any?
    
    public init() {}
        
    public func transformFromJSON(_ value: Any?) -> Int? {
        var result_ty: Int?
        guard let json_ty = value else {
            return result_ty
        }
        if json_ty is NSNumber, let numberValue_ty = json_ty as? NSNumber {
            result_ty = numberValue_ty.intValue
        } else if json_ty is Int, let intValue_ty = json_ty as? Int {
            result_ty = intValue_ty
        } else if json_ty is String,let stringValue_ty = json_ty as? String {
            result_ty = Int(stringValue_ty)
        }
        return result_ty
    }
    
    public func transformToJSON(_ value: Int?) -> Any?? {
        guard let _value_ty = value else {
            return nil
        }
        return "\(_value_ty)"
    }
}

