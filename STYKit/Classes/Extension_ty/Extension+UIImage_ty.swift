//
//  UIImage+Extension.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UIImage {
    
    enum UIImageType_ty: String {
        case png_ty = "png_ty"
        case pdf_ty = "pdf_ty"
    }
    
    convenience init?(name_ty: String, type_ty: UIImageType_ty = .png_ty) {
        // 使用【use_frameworks!】
        let mainPath_ty = Bundle.main.bundlePath
        var bundler_ty  = Bundle(path: mainPath_ty + "/Frameworks/STYKit.framework/STYKit.bundle")
        if bundler_ty == nil {
            bundler_ty = Bundle(path: mainPath_ty + "/STYKit.bundle")
        }
        if let path_ty = bundler_ty?.path(forResource: name_ty, ofType: type_ty.rawValue) {
            let url_ty = URL(fileURLWithPath: path_ty)
            if let data_ty = try? Data(contentsOf: url_ty) {
                self.init(data: data_ty)
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
    func compressSize_ty(kb_ty maxSize_ty: CGFloat) -> Data? {
        var compression_ty: CGFloat = 1
        guard var data_ty = self.jpegData(compressionQuality: 1), data_ty.sizeKB_ty > maxSize_ty else {
            return self.jpegData(compressionQuality: 1)
        }
        var max_ty: CGFloat = 1
        var min_ty: CGFloat = 0
        // 压缩比例
        for _ in 0..<6 {
            compression_ty = (max_ty + min_ty)/2
            guard let _data_ty = self.jpegData(compressionQuality: compression_ty) else {
                return nil
            }
            data_ty = _data_ty
            if data_ty.sizeKB_ty < maxSize_ty * 0.9 {
                min_ty = compression_ty
            } else if data_ty.sizeKB_ty > maxSize_ty {
                max_ty = compression_ty
            } else {
                break
            }
        }
        guard data_ty.sizeKB_ty >= maxSize_ty else {
            return data_ty
        }
        // 压缩尺寸
        var lastSize_ty: CGFloat = .zero
        while data_ty.sizeKB_ty > maxSize_ty && data_ty.sizeKB_ty != lastSize_ty {
            lastSize_ty  = data_ty.sizeKB_ty
            let scale_ty = CGFloat(sqrtf(Float(maxSize_ty) / Float(data_ty.count)))
            let size_ty = CGSize(width: self.size.width * scale_ty, height: self.size.height * scale_ty)
            UIGraphicsBeginImageContext(size_ty)
            self.draw(in: CGRect(origin: .zero, size: size_ty))
            UIGraphicsEndImageContext()
            guard let imageData_ty = self.jpegData(compressionQuality: compression_ty) else {
                return nil
            }
            data_ty = imageData_ty
        }
        return data_ty
    }
    
    /// 统一压缩方式
    /// - Parameter size: 尺寸
    /// - Returns: 压缩后图片尺寸
    func compress_ty(size_ty: CGSize, compressionQuality_ty: CGFloat) -> Data? {
        // 压缩尺寸
        UIGraphicsBeginImageContext(size_ty)
        self.draw(in: CGRect(origin: .zero, size: size_ty))
        UIGraphicsEndImageContext()
        guard let imageData_ty = self.jpegData(compressionQuality: compressionQuality_ty) else {
            return nil
        }
        return imageData_ty
    }
}
