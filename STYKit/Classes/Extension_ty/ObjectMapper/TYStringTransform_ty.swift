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
        var result: String?
        guard let json = value else {
            return result
        }
        if json is String {
            result = json as? String
        } else if json is Int {
            result = "\(json)"
        }
        return result
    }
    
    public func transformToJSON(_ value: String?) -> Any?? {
        guard let _value = value else {
            return nil
        }
        return _value
    }
}

