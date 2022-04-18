//
//  TYDateTransform_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import ObjectMapper

public class TYDateTransform_ty: TransformType {

    public typealias Object = Date
    
    public typealias JSON = Any?
    
    public init() {}
        
    public func transformFromJSON(_ value: Any?) -> Date? {
        var result_ty: Date?
        guard let json_ty = value else {
            return result_ty
        }
        if json_ty is Int, var intValue_ty = json_ty as? Int {
            intValue_ty /= 1000
            result_ty = Date(timeIntervalSince1970: TimeInterval(intValue_ty))
        } else if json_ty is Double, var doubleValue_ty = json_ty as? TimeInterval {
            doubleValue_ty /= 1000
            result_ty = Date(timeIntervalSince1970: doubleValue_ty)
        } else if json_ty is Float, var floatValue_ty = json_ty as? Float {
            floatValue_ty /= 1000
            result_ty = Date(timeIntervalSince1970: TimeInterval(floatValue_ty))
        } else if json_ty is String, let stringValue_ty = json_ty as? String {
            var doulbeValue = Double(stringValue_ty) ?? 0
            doulbeValue    /= 1000
            result_ty = Date(timeIntervalSince1970: doulbeValue)
        }
        return result_ty
    }
    
    public func transformToJSON(_ value: Date?) -> Any?? {
        guard let _value_ty = value else {
            return nil
        }
        return Int(_value_ty.timeIntervalSince1970 * 1000)
    }
}

