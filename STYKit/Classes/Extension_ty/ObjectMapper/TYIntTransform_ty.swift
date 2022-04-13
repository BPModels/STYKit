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
        var result: Int?
        guard let json = value else {
            return result
        }
        if json is NSNumber, let numberValue = json as? NSNumber {
            result = numberValue.intValue
        } else if json is Int, let intValue = json as? Int {
            result = intValue
        } else if json is String,let stringValue = json as? String {
            result = Int(stringValue)
        }
        return result
    }
    
    public func transformToJSON(_ value: Int?) -> Any?? {
        guard let _value = value else {
            return nil
        }
        return "\(_value)"
    }
}

