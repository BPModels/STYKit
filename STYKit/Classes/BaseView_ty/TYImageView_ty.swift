//
//  TYImageView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation
import SDWebImage

open class TYImageView_ty: UIImageView {
    
    /// 设置图片
    /// - Parameters:
    ///   - imageStr: 图片远端地址
    ///   - placeholdImage: 默认图片
    ///   - downloadProgress: 下载进度
    ///   - complete: 完成回调
    open func setImage_ty(imageStr_ty: String?, placeholdImage_ty: UIImage? = nil, downloadProgress_ty: SDImageLoaderProgressBlock? = nil,  complete_ty: SDExternalCompletionBlock? = nil) {
        var _imageStr_ty: String? = imageStr_ty
        if imageStr_ty?.hasChinese_ty() ?? false {
            _imageStr_ty = imageStr_ty?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        guard let imageStr_ty = _imageStr_ty else {
            complete_ty?(nil, nil, .none, nil)
            return
        }
        DispatchQueue.global().async {
            let imageUrl_ty = URL(string: imageStr_ty)
            self.sd_setImage(with: imageUrl_ty, placeholderImage: placeholdImage_ty, progress: downloadProgress_ty) { image_ty, error_ty, cacheType_ty, url_ty in
                DispatchQueue.main.async {
                    self.image = image_ty
                    complete_ty?(image_ty, error_ty, cacheType_ty, url_ty)
                }
            }
        }
    }
    
    open func setCorner_ty(redius_ty: CGFloat) {
        self.layer.cornerRadius  = redius_ty
        self.layer.masksToBounds = true
    }
}
