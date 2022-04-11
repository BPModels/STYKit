//
//  UIImage+Extension.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UIImage {
    
    enum UIImageType: String {
        case png = "png"
        case pdf = "pdf"
    }
    
    class func name(_ name: String, type: UIImageType) -> UIImage? {
        guard let imagePath = Bundle.main.path(forResource: name, ofType: type.rawValue) else {
            return nil
        }
        return UIImage(contentsOfFile: imagePath)
    }
}
