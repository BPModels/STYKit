//
//  UIImage+Extension.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UIImage {
    
    enum UIImageType_ty: String {
        case png = "png"
        case pdf = "pdf"
    }
    
    convenience init?(name_ty: String, type: UIImageType_ty = .png) {
        // 使用【use_frameworks!】
        let mainPath = Bundle.main.bundlePath
        var bundler  = Bundle(path: mainPath + "/Frameworks/STYKit.framework/STYKit.bundle")
        if bundler == nil {
            bundler = Bundle(path: mainPath + "/STYKit.bundle")
        }
        if let path = bundler?.path(forResource: name_ty, ofType: type.rawValue) {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url) {
                self.init(data: data)
            } else {
                self.init()
            }
        } else {
            self.init()
        }
    }
//    
//    class func name_ty(_ name: String, type: UIImageType_ty) -> UIImage? {
//        guard let imagePath = Bundle.main.path(forResource: name, ofType: type.rawValue) else {
//            return nil
//        }
//        return UIImage(contentsOfFile: imagePath)
//    }
    
    /// 统一压缩方式
    /// - Parameter maxSize: 单位：KB
    /// - Returns: 压缩后最佳尺寸
    func compressSize_ty(kb maxSize: CGFloat) -> Data? {
        var compression: CGFloat = 1
        guard var data = self.jpegData(compressionQuality: 1), data.sizeKB_ty > maxSize else {
            return self.jpegData(compressionQuality: 1)
        }
        var max: CGFloat = 1
        var min: CGFloat = 0
        // 压缩比例
        for _ in 0..<6 {
            compression = (max + min)/2
            guard let _data = self.jpegData(compressionQuality: compression) else {
                return nil
            }
            data = _data
            if data.sizeKB_ty < maxSize * 0.9 {
                min = compression
            } else if data.sizeKB_ty > maxSize {
                max = compression
            } else {
                break
            }
        }
        guard data.sizeKB_ty >= maxSize else {
            return data
        }
        // 压缩尺寸
        var lastSize: CGFloat = .zero
        while data.sizeKB_ty > maxSize && data.sizeKB_ty != lastSize {
            lastSize  = data.sizeKB_ty
            let scale = CGFloat(sqrtf(Float(maxSize) / Float(data.count)))
            let size  = CGSize(width: self.size.width * scale, height: self.size.height * scale)
            UIGraphicsBeginImageContext(size)
            self.draw(in: CGRect(origin: .zero, size: size))
            UIGraphicsEndImageContext()
            guard let imageData = self.jpegData(compressionQuality: compression) else {
                return nil
            }
            data = imageData
        }
        return data
    }
    
    /// 统一压缩方式
    /// - Parameter size: 尺寸
    /// - Returns: 压缩后图片尺寸
    func compress_ty(size: CGSize, compressionQuality: CGFloat) -> Data? {
        // 压缩尺寸
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(origin: .zero, size: size))
        UIGraphicsEndImageContext()
        guard let imageData = self.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        return imageData
    }
}
