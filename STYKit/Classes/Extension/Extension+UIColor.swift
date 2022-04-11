//
//  UIColor+Extension_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UIColor {
    
    class func RGBA_ty(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red/255, green: green/255, blue: blue/255, alpha: alpha)
        } else {
            return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
        }
    }
    
    
    /// 小红点 (red: 255, green: 71, blue: 71)
    static let red0  = RGBA_ty(red: 255, green: 15, blue: 75)
    /// 文字 (red: 166, green: 166, blue: 166)
    static let gray0 = RGBA_ty(red: 166, green: 166, blue: 166)
    
    static let theme = RGBA_ty(red: 255, green: 196, blue: 47)
}
