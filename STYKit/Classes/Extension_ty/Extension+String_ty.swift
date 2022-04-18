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
        let regex_ty = "^.*[\\u4e00-\\u9fa5].*$"
        let pred_ty = NSPredicate(format: "SELF MATCHES %@", regex_ty)
        return pred_ty.evaluate(with: self)
    }
    
    /// 是否仅数字
    func isOnlyNumber_ty() -> Bool {
        let regex_ty = "^[0-9]+$"
        let pred_ty = NSPredicate(format: "SELF MATCHES %@", regex_ty)
        return pred_ty.evaluate(with: self)
    }
    
    /// 是否不为空
    var isNotEmpty_ty: Bool {
        return !isEmpty
    }
    
    /// 获取指定范围的内容
    func substring_ty(fromIndex_ty minIndex_ty: Int, toIndex_ty maxIndex_ty: Int) -> String {
        let _maxIndex_ty = maxIndex_ty >= self.count ? self.count - 1 : maxIndex_ty
        let start_ty = index(startIndex, offsetBy: minIndex_ty)
        guard let end_ty = index(startIndex, offsetBy: _maxIndex_ty, limitedBy: endIndex) else {
            return ""
        }
        
        let range_ty = start_ty ... end_ty
        return String(self[range_ty])
    }
    
    /// 根据字体和画布高度,计算文字在画布上的宽度
    /// - parameter font: 字体
    /// - parameter height: 限制的高度
    func textWidth_ty(font_ty: UIFont, height_ty: CGFloat) -> CGFloat {
        let rect_ty = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height_ty), options: .usesLineFragmentOrigin, attributes: [.font: font_ty], context: nil)
        return ceil(rect_ty.width)
    }
    
    /// 根据字体和画布宽度,计算文字在画布上的高度
    /// - parameter font: 字体
    /// - parameter width: 限制的宽度
    func textHeight_ty(font_ty: UIFont, width_ty: CGFloat) -> CGFloat {
        let rect_ty = NSString(string: self).boundingRect(with: CGSize(width: width_ty, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font_ty], context: nil)
        return ceil(rect_ty.height)
    }
}

import CommonCrypto
public extension String {
    /// 获取MD5值
    func md5_ty() -> String {
        let hash_ty         = NSMutableString()
        let str_ty          = self.cString(using: String.Encoding.utf8)
        let strLength_ty    = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLength_ty = Int(CC_MD5_DIGEST_LENGTH)
        let result_ty       = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)

        CC_MD5(str_ty!, strLength_ty, result_ty)
        for i_ty in 0..<digestLength_ty {
            hash_ty.appendFormat("%02x", result_ty[i_ty])
        }
        free(result_ty)
        return hash_ty as String
    }
}
