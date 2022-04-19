//
//  UIColor+Extension_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UIColor {
    
    /// 十六进制颜色值
    /// - parameter hex: 十六进制值,例如: 0x000fff
    /// - parameter alpha: 透明度
    class func hex_ty(_ hex_ty: UInt32, alpha_ty: CGFloat = 1.0) -> UIColor {
        if hex_ty > 0xFFF {
            let divisor_ty = CGFloat(255)
            let red_ty     = CGFloat((hex_ty & 0xFF0000) >> 16) / divisor_ty
            let green_ty   = CGFloat((hex_ty & 0xFF00  ) >> 8)  / divisor_ty
            let blue_ty    = CGFloat( hex_ty & 0xFF    )        / divisor_ty
            return UIColor(red: red_ty, green: green_ty, blue: blue_ty, alpha: alpha_ty)
        } else {
            let divisor_ty = CGFloat(15)
            let red_ty     = CGFloat((hex_ty & 0xF00) >> 8) / divisor_ty
            let green_ty   = CGFloat((hex_ty & 0x0F0) >> 4) / divisor_ty
            let blue_ty    = CGFloat( hex_ty & 0x00F      ) / divisor_ty
            return UIColor(red: red_ty, green: green_ty, blue: blue_ty, alpha: alpha_ty)
        }
    }
    
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

public extension UIColor {
    
    /// 根据方向,设置渐变色
    ///
    /// - Parameters:
    ///   - size: 渐变区域大小
    ///   - colors: 渐变色数组
    ///   - direction: 渐变方向
    /// - Returns: 渐变后的颜色,如果设置失败,则返回nil
    /// - note: 设置前,一定要确定当前View的高宽!!!否则无法准确的绘制
    class func gradientColor_ty(with_ty size_ty: CGSize, colors_ty: [CGColor], direction_ty: TYGradientDirectionType_ty) -> UIColor? {
        switch direction_ty {
        case .horizontal_ty:
            return gradientColor_ty(with_ty: size_ty, colors_ty: colors_ty, startPoint_ty: CGPoint(x: 0, y: 0.5), endPoint_ty: CGPoint(x: 1, y: 0.5))
        case .vertical_ty:
            return gradientColor_ty(with_ty: size_ty, colors_ty: colors_ty, startPoint_ty: CGPoint(x: 0.5, y: 0), endPoint_ty: CGPoint(x: 0.5, y: 1))
        case .leftTop_ty:
            return gradientColor_ty(with_ty: size_ty, colors_ty: colors_ty, startPoint_ty: CGPoint(x: 0, y: 0), endPoint_ty: CGPoint(x: 1, y: 1))
        case .leftBottom_ty:
            return gradientColor_ty(with_ty: size_ty, colors_ty: colors_ty, startPoint_ty: CGPoint(x: 0, y: 1), endPoint_ty: CGPoint(x: 1, y: 0))
        }
    }

    /// 设置渐变色
    /// - parameter size: 渐变文字区域的大小.也就是用于绘制的区域
    /// - parameter colors: 渐变的颜色数组,从左到右顺序渐变,区域均匀分布
    /// - parameter startPoint: 渐变开始坐标
    /// - parameter endPoint: 渐变结束坐标
    /// - returns: 返回一个渐变的color,如果绘制失败,则返回nil;
    class func gradientColor_ty(with_ty size_ty: CGSize, colors_ty: [CGColor], startPoint_ty: CGPoint, endPoint_ty: CGPoint) -> UIColor? {
        autoreleasepool {
            // 设置画布,开始准备绘制
            UIGraphicsBeginImageContextWithOptions(size_ty, false, kScreenScale_ty)
            // 获取当前画布上下文,用于操作画布对象
            guard let context_ty     = UIGraphicsGetCurrentContext() else { return nil }
            // 创建RGB空间
            let colorSpaceRef_ty     = CGColorSpaceCreateDeviceRGB()
            // 在RGB空间中绘制渐变色,可设置渐变色占比,默认均分
            guard let gradientRef_ty = CGGradient(colorsSpace: colorSpaceRef_ty, colors: colors_ty as CFArray, locations: nil) else { return nil }
            // 设置渐变起始坐标
            let startPoint_ty        = CGPoint(x: size_ty.width * startPoint_ty.x, y: size_ty.height * startPoint_ty.y)
            // 设置渐变结束坐标
            let endPoint_ty          = CGPoint(x: size_ty.width * endPoint_ty.x, y: size_ty.height * endPoint_ty.y)
            // 开始绘制图片
            context_ty.drawLinearGradient(gradientRef_ty, start: startPoint_ty, end: endPoint_ty, options: CGGradientDrawingOptions(rawValue: CGGradientDrawingOptions.drawsBeforeStartLocation.rawValue | CGGradientDrawingOptions.drawsAfterEndLocation.rawValue))
            
            // 获取渐变图片
            if let gradientImage_ty = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return UIColor(patternImage: gradientImage_ty)
            }
            UIGraphicsEndImageContext()
            return nil
        }
        
       
    }
}
