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
    
    class func custom_ty(_ type: FontType_ty, size: CGFloat) -> UIFont {
        if let font = UIFont(name: type.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
}
