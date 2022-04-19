//
//  UIImage+Extension.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UIImage {
    
    enum UIImageType_ty: String {
        case png_ty = "png"
        case pdf_ty = "pdf"
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
    
    /// 节约内存的ImageIO缩放
    /// - Parameters:
    ///   - size: 图片尺寸
    ///   - scale: 缩放比例
    ///   - orientation: 图片方向
    func scaledImage_ty(_ size_ty: CGSize, scale_ty: CGFloat, orientation_ty: UIImage.Orientation = .up) -> UIImage {
        let maxpixelSize_ty = max(size_ty.width, size_ty.height)
        let options_ty = [kCGImageSourceCreateThumbnailFromImageAlways : kCFBooleanTrue!, kCGImageSourceThumbnailMaxPixelSize : maxpixelSize_ty] as CFDictionary
        let dataOption_ty: Data? = {
            if let data_ty = self.pngData() {
                return data_ty
            } else {
                return self.jpegData(compressionQuality: 1.0)
            }
        }()
        guard let data_ty: CFData = dataOption_ty as CFData?, let sourceRef_ty = CGImageSourceCreateWithData(data_ty, nil), let imageRef_ty = CGImageSourceCreateThumbnailAtIndex(sourceRef_ty, 0, options_ty) else {
            return self
        }
        let resultImage_ty = UIImage(cgImage: imageRef_ty, scale: scale_ty, orientation: orientation_ty)
        return resultImage_ty
    }
    
    //将图片缩放成指定尺寸（多余部分自动删除）
    func scaled_ty(_ newSize_ty: CGSize) -> UIImage {
        autoreleasepool {
            //计算比例
            let aspectWidth_ty  = newSize_ty.width/size.width
            let aspectHeight_ty = newSize_ty.height/size.height
            let aspectRatio_ty = max(aspectWidth_ty, aspectHeight_ty)
            
            //图片绘制区域
            var scaledImageRect_ty         = CGRect.zero
            scaledImageRect_ty.size.width  = size.width * aspectRatio_ty
            scaledImageRect_ty.size.height = size.height * aspectRatio_ty
            scaledImageRect_ty.origin.x    = (newSize_ty.width - size.width * aspectRatio_ty) / 2.0
            scaledImageRect_ty.origin.y    = (newSize_ty.height - size.height * aspectRatio_ty) / 2.0
            
            //绘制并获取最终图片
            UIGraphicsBeginImageContextWithOptions(newSize_ty, false, 0)
            draw(in: scaledImageRect_ty)
            let scaledImage_ty = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return scaledImage_ty!
        }
    }
    
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
    
    /// 通过颜色绘制图片
    class func imageWithColor_ty(_ color_ty: UIColor, width_ty: CGFloat = 1.0, height_ty: CGFloat = 1.0, cornerRadius_ty: CGFloat = 0) -> UIImage {
        autoreleasepool {
            let rect_ty = CGRect(x: 0, y: 0, width: width_ty, height: height_ty)
            let roundedRect_ty: UIBezierPath = UIBezierPath(roundedRect: rect_ty, cornerRadius: cornerRadius_ty)
            roundedRect_ty.lineWidth = 0
            
            UIGraphicsBeginImageContextWithOptions(rect_ty.size, false, 0.0)
            color_ty.setFill()
            roundedRect_ty.fill()
            roundedRect_ty.stroke()
            roundedRect_ty.addClip()
            var image_ty: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            image_ty = image_ty?.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius_ty, left: cornerRadius_ty, bottom: cornerRadius_ty, right: cornerRadius_ty))
            return image_ty!
        }
    }
}
