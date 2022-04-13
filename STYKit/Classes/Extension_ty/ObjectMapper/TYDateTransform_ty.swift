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
        var result: Date?
        guard let json = value else {
            return result
        }
        if json is Int, var intValue = json as? Int {
            intValue /= 1000
            result = Date(timeIntervalSince1970: TimeInterval(intValue))
        } else if json is Double, var doubleValue = json as? TimeInterval {
            doubleValue /= 1000
            result = Date(timeIntervalSince1970: doubleValue)
        } else if json is Float, var floatValue = json as? Float {
            floatValue /= 1000
            result = Date(timeIntervalSince1970: TimeInterval(floatValue))
        } else if json is String, let stringValue = json as? String {
            var doulbeValue = Double(stringValue) ?? 0
            doulbeValue    /= 1000
            result = Date(timeIntervalSince1970: doulbeValue)
        }
        return result
    }
    
    public func transformToJSON(_ value: Date?) -> Any?? {
        guard let _value = value else {
            return nil
        }
        return Int(_value.timeIntervalSince1970 * 1000)
    }
}

