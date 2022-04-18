//
//  UIFont+Extension.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UIFont {
    
    enum FontType_ty: String {
        case PingFangTCRegular_ty  = "PingFangSC-Regular"
        case PingFangTCMedium_ty   = "PingFangSC-Medium"
        case PingFangTCSemibold_ty = "PingFangSC-Semibold"
        case PingFangTCLight_ty    = "PingFangSC-Light"
        case DINAlternateBold_ty   = "DINAlternate-Bold"
    }
    
    class func regular_ty(_ size_ty: CGFloat) -> UIFont {
        return self.custom_ty(.PingFangTCRegular_ty, size_ty)
    }
    
    class func medium_ty(_ size_ty: CGFloat) -> UIFont {
        return self.custom_ty(.PingFangTCMedium_ty, size_ty)
    }
    
    class func semibold_ty(_ size_ty: CGFloat) -> UIFont {
        return self.custom_ty(.PingFangTCSemibold_ty, size_ty)
    }
    
    class func light_ty(_ size_ty: CGFloat) -> UIFont {
        return self.custom_ty(.PingFangTCLight_ty, size_ty)
    }
    
    class func DIN_ty(_ size_ty: CGFloat) -> UIFont {
        return self.custom_ty(.DINAlternateBold_ty, size_ty)
    }
    
    class func custom_ty(_ type: FontType_ty, _ size_ty: CGFloat) -> UIFont {
        if let font = UIFont(name: type.rawValue, size: size_ty) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size_ty)
        }
    }
}
