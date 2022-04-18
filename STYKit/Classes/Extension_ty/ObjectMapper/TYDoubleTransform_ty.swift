//
//  TYDoubleTransform_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import ObjectMapper

public class TYDoubleTransform_ty: TransformType {

    public typealias Object = Double
    
    public typealias JSON = Any?
    
    public init() {}
        
    public func transformFromJSON(_ value: Any?) -> Double? {
        var result_ty: Double?
        guard let json_ty = value else {
            return result_ty
        }
        if json_ty is NSNumber, let numberValue_ty = json_ty as? NSNumber {
            result_ty = numberValue_ty.doubleValue
        } else if json_ty is Int, let intValue_ty = json_ty as? Int {
            result_ty = Double(intValue_ty)
        } else if json_ty is String,let stringValue_ty = json_ty as? String {
            result_ty = self.convertDouble_ty(value_ty: stringValue_ty, scale_ty: 2)
            
        }
        return result_ty
    }
    
    public func transformToJSON(_ value: Double?) -> Any?? {
        guard let _value_ty = value else {
            return nil
        }
        return self.convertDouble_ty(value_ty: "\(_value_ty)", scale_ty: 2)
    }
    
    // TODO: ==== Tools ====
    private func convertDouble_ty(value_ty: String, scale_ty: Int16) -> Double {
        let number_ty        = NSDecimalNumber(string: value_ty)
        let numberHandle_ty  = NSDecimalNumberHandler(roundingMode: .plain, scale: scale_ty, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let rundingNumber_ty = number_ty.rounding(accordingToBehavior: numberHandle_ty)
        return rundingNumber_ty.doubleValue
    }
}

