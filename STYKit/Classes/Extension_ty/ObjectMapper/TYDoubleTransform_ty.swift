//
//  TYDoubleTransform_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import ObjectMapper

class TYDoubleTransform_ty: TransformType {

    typealias Object = Double
    
    typealias JSON = Any?
    
    init() {}
        
    func transformFromJSON(_ value: Any?) -> Double? {
        var result: Double?
        guard let json = value else {
            return result
        }
        if json is NSNumber, let numberValue = json as? NSNumber {
            result = numberValue.doubleValue
        } else if json is Int, let intValue = json as? Int {
            result = Double(intValue)
        } else if json is String,let stringValue = json as? String {
            result = self.convertDouble_ty(value: stringValue, scale: 2)
            
        }
        return result
    }
    
    func transformToJSON(_ value: Double?) -> Any?? {
        guard let _value = value else {
            return nil
        }
        return self.convertDouble_ty(value: "\(_value)", scale: 2)
    }
    
    // TODO: ==== Tools ====
    private func convertDouble_ty(value: String, scale: Int16) -> Double {
        let number        = NSDecimalNumber(string: value)
        let numberHandle  = NSDecimalNumberHandler(roundingMode: .plain, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let rundingNumber = number.rounding(accordingToBehavior: numberHandle)
        return rundingNumber.doubleValue
    }
}

