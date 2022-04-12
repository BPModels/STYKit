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
    
    /// 获得随机颜色
    /// - Returns: 随机颜色
    static func randomColor_ty(alpheRandom: Bool = false) -> UIColor {
        let red   = CGFloat.random(in: 0...255)
        let green = CGFloat.random(in: 0...255)
        let blue  = CGFloat.random(in: 0...255)
        var alphe = CGFloat(1)
        if alpheRandom {
            alphe = CGFloat.random(in: 0...1)
        }
        return RGBA_ty(red: red, green: green, blue: blue, alpha: alphe)
    }
    
    /// 文字 (red: 34, green: 34, blue: 34)
    static let black0_ty = RGBA_ty(red: 34, green: 34, blue: 34)
    /// 小红点 (red: 255, green: 71, blue: 71)
    static let red0_ty  = RGBA_ty(red: 255, green: 15, blue: 75)
    /// 文字 (red: 166, green: 166, blue: 166)
    static let gray0_ty = RGBA_ty(red: 166, green: 166, blue: 166)
    /// 分割线 (red: 238, green: 238, blue: 238)
    static let gray4_ty = RGBA_ty(red: 238, green: 238, blue: 238)
    
    static let theme_ty = RGBA_ty(red: 255, green: 196, blue: 47)
}
