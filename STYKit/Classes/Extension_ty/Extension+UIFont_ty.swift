//
//  UIFont+Extension.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UIFont {
    
    enum FontType_ty: String {
        case PingFangTCRegular  = "PingFangSC-Regular"
        case PingFangTCMedium   = "PingFangSC-Medium"
        case PingFangTCSemibold = "PingFangSC-Semibold"
        case PingFangTCLight    = "PingFangSC-Light"
        case DINAlternateBold   = "DINAlternate-Bold"
    }
    
    class func regular_ty(size: CGFloat) -> UIFont {
        return self.custom_ty(.PingFangTCRegular, size: size)
    }
    
    class func medium_ty(size: CGFloat) -> UIFont {
        return self.custom_ty(.PingFangTCMedium, size: size)
    }
    
    class func semibold_ty(size: CGFloat) -> UIFont {
        return self.custom_ty(.PingFangTCSemibold, size: size)
    }
    
    class func light_ty(size: CGFloat) -> UIFont {
        return self.custom_ty(.PingFangTCLight, size: size)
    }
    
    class func DIN_ty(size: CGFloat) -> UIFont {
        return self.custom_ty(.DINAlternateBold, size: size)
    }
    
    class func custom_ty(_ type: FontType_ty, size: CGFloat) -> UIFont {
        if let font = UIFont(name: type.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
}
