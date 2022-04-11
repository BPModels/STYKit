//
//  String+Extension.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension String {
    
    /// 是否包含中文
    func hasChinese_ty() -> Bool {
        let regex = "^.*[\\u4e00-\\u9fa5].*$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    
    /// 是否仅数字
    func isOnlyNumber_ty() -> Bool {
        let regex = "^[0-9]+$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    
    /// 是否不为空
    var isNotEmpty_ty: Bool {
        return !isEmpty
    }
    
    /// 获取指定范围的内容
    func substring_ty(fromIndex minIndex: Int, toIndex maxIndex: Int) -> String {
        let _maxIndex = maxIndex >= self.count ? self.count - 1 : maxIndex
        let start = index(startIndex, offsetBy: minIndex)
        guard let end = index(startIndex, offsetBy: _maxIndex, limitedBy: endIndex) else {
            return ""
        }
        
        let range = start ... end
        return String(self[range])
    }
}
