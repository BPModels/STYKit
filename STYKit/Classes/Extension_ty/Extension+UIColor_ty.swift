//
//  UIColor+Extension_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UIColor {
    
    class func RGBA_ty(red_ty: CGFloat, green_ty: CGFloat, blue_ty: CGFloat, alpha_ty: CGFloat = 1.0) -> UIColor {
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red_ty/255, green: green_ty/255, blue: blue_ty/255, alpha: alpha_ty)
        } else {
            return UIColor(red: red_ty/255, green: green_ty/255, blue: blue_ty/255, alpha: alpha_ty)
        }
    }
    
    /// 获得随机颜色
    /// - Returns: 随机颜色
    static func randomColor_ty(alpheRandom_ty: Bool = false) -> UIColor {
        let red_ty   = CGFloat.random(in: 0...255)
        let green_ty = CGFloat.random(in: 0...255)
        let blue_ty  = CGFloat.random(in: 0...255)
        var alphe_ty = CGFloat(1)
        if alpheRandom_ty {
            alphe_ty = CGFloat.random(in: 0...1)
        }
        return RGBA_ty(red_ty: red_ty, green_ty: green_ty, blue_ty: blue_ty, alpha_ty: alphe_ty)
    }
    
    /// 文字 (red: 34, green: 34, blue: 34)
    static let black0_ty = RGBA_ty(red_ty: 34, green_ty: 34, blue_ty: 34)
    /// 小红点 (red: 255, green: 71, blue: 71)
    static let red0_ty  = RGBA_ty(red_ty: 255, green_ty: 15, blue_ty: 75)
    /// 文字 (red: 166, green: 166, blue: 166)
    static let gray0_ty = RGBA_ty(red_ty: 166, green_ty: 166, blue_ty: 166)
    /// 分割线 (red: 238, green: 238, blue: 238)
    static let gray4_ty = RGBA_ty(red_ty: 238, green_ty: 238, blue_ty: 238)
    
    static let theme_ty = RGBA_ty(red_ty: 255, green_ty: 196, blue_ty: 47)
}
