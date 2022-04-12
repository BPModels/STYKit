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
    
    /// 根据字体和画布高度,计算文字在画布上的宽度
    /// - parameter font: 字体
    /// - parameter height: 限制的高度
    func textWidth_ty(font: UIFont, height: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.width)
    }
    
    /// 根据字体和画布宽度,计算文字在画布上的高度
    /// - parameter font: 字体
    /// - parameter width: 限制的宽度
    func textHeight_ty(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.height)
    }
}

import CommonCrypto
public extension String {
    /// 获取MD5值
    func md5_ty() -> String {
        let hash         = NSMutableString()
        let str          = self.cString(using: String.Encoding.utf8)
        let strLength    = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result       = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)

        CC_MD5(str!, strLength, result)
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return hash as String
    }
}
