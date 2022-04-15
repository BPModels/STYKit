//
//  Extension+Dictionary.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Foundation

public extension Dictionary {
    func toJson_ty() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0)), let str = String(data: data, encoding: String.Encoding.utf8) else { return "" }
        return str
    }
}
