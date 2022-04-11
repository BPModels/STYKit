//
//  UIColor+Extension_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UIColor {
    
    class func RGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red/255, green: green/255, blue: blue/255, alpha: alpha)
        } else {
            return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
        }
    }
    
    static let theme = RGBA(red: 255, green: 196, blue: 47)
}
