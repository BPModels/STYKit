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
    
    /// 转整型
    var intValue_ty: Int {
        return Int(self) ?? 0
    }
    
    /// 转浮点型
    var floatValue_ty: Float {
        return Float(self) ?? 0
    }
    
    /// 转换成Double类型
    func doubleValue_ty(scale_ty: Int16) -> Double {
        let number_ty        = NSDecimalNumber(string: self)
        let numberHandle_ty  = NSDecimalNumberHandler(roundingMode: .plain, scale: scale_ty, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let rundingNumber_ty = number_ty.rounding(accordingToBehavior: numberHandle_ty)
        return rundingNumber_ty.doubleValue
    }
    
    /// 获取指定长度的内容
    func substring_ty(fromIndex_ty from_ty: Int, length_ty: Int) -> String {
        let start_ty = index(startIndex, offsetBy: from_ty)
        let end_ty   = index(start_ty, offsetBy: length_ty)

        let range_ty = start_ty ..< end_ty
        return String(self[range_ty])
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
    
    /// 转换Json格式的String到Diction类型,一般用于解析接口返回结果
    ///
    /// String必须包含{}这两个大括号,否则直接进入catch块,报错:The data couldn’t be read because it isn’t in the correct format.
    ///
    /// 遇到不存在的key,返回对象为nil
    func toDictionary_ty() -> [String : Any] {
        guard self.isNotEmpty_ty else { return [:] }
        var dict_ty = [String:Any]()
        if let data_ty = self.data(using: .utf8) {
            do {
                let json_ty = try JSONSerialization.jsonObject(with: data_ty, options: [])
                guard let jsonDict_ty = json_ty as? [AnyHashable:Any], let dictTmp_ty = jsonDict_ty as? [String:Any] else {
                    return dict_ty
                }
                dict_ty = dictTmp_ty
                return dict_ty
            } catch {
                print(error.localizedDescription)
            }
        }
        return dict_ty
    }
    
    /// 转换成Json格式化
    func toJson_ty() -> String {
        
        if (self.starts(with: "{") || self.starts(with: "[")){
            var level = 0
            var jsonFormatString = String()
            
            func getLevelStr(level:Int) -> String {
                var string = ""
                for _ in 0..<level {
                    string.append("\t")
                }
                return string
            }
            
            for char in self {
                
                if level > 0 && "\n" == jsonFormatString.last {
                    jsonFormatString.append(getLevelStr(level: level))
                }
                
                switch char {
                    
                case "{":
                    fallthrough
                case "[":
                    level += 1
                    jsonFormatString.append(char)
                    jsonFormatString.append("\n")
                case ",":
                    jsonFormatString.append(char)
                    jsonFormatString.append("\n")
                case "}":
                    fallthrough
                case "]":
                    level -= 1;
                    jsonFormatString.append("\n")
                    jsonFormatString.append(getLevelStr(level: level));
                    jsonFormatString.append(char);
                    break;
                default:
                    jsonFormatString.append(char)
                }
            }
            return jsonFormatString;
        }
        
        return self
    }
    
//    /// 将文字中的表情符转换成表情显示
//    func toEmoji_ty(font_ty: UIFont, color_ty: UIColor) -> NSMutableAttributedString {
//        let pattern_ty = "\\[.{1,3}\\]"
//        let textAttributes_ty = [NSAttributedString.Key.font : font_ty, NSAttributedString.Key.foregroundColor : color_ty]
//
//        let attrStr_ty = NSMutableAttributedString(string: self, attributes: textAttributes_ty)
//        var regex_ty: NSRegularExpression?
//        do {
//            regex_ty = try NSRegularExpression(pattern: pattern_ty, options: .caseInsensitive)
//        } catch let error_ty as NSError {
//            print(error_ty.localizedDescription)
//        }
//        guard var matches_ty = regex_ty?.matches(in: self, options: .withoutAnchoringBounds, range: NSMakeRange(0, attrStr_ty.string.count)), !matches_ty.isEmpty else {
//            return attrStr_ty
//        }
//
//        matches_ty.reverse()
//        for result_ty in matches_ty {
//            let range_ty     = result_ty.range
//            let emojiStr_ty  = (self as NSString).substring(with: range_ty)
//            let imagePath_ty = "emoji.bundle/" + emojiStr_ty + ".png"
//            guard let emojiImage_ty = UIImage(named: imagePath_ty) else {
//                continue
//            }
//            // 创建一个NSTextAttachment
//            let attachment_ty = NSTextAttachment()
//            attachment_ty.image     = emojiImage_ty
//            attachment_ty.name_ty   = emojiStr_ty
//            let attachmentHeight_ty = font_ty.lineHeight
//            let attachmentWidth_ty  = attachmentHeight_ty * emojiImage_ty.size.width / emojiImage_ty.size.height
//            let offsetY_ty          = (font_ty.capHeight - font_ty.lineHeight)/2
//            attachment_ty.bounds    = CGRect(x: 0, y: offsetY_ty, width: attachmentWidth_ty, height: attachmentHeight_ty)
//            let emojiAttr_ty = NSAttributedString(attachment: attachment_ty)
//            attrStr_ty.replaceCharacters(in: range_ty, with: emojiAttr_ty)
//        }
//        return attrStr_ty
//    }
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
