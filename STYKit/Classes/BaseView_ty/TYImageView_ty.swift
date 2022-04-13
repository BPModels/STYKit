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
    public func setImage_ty(imageStr: String, placeholdImage: UIImage? = nil, downloadProgress: SDImageLoaderProgressBlock?,  complete: SDExternalCompletionBlock?) {
        var _imageStr: String? = imageStr
        if imageStr.hasChinese_ty() {
            _imageStr = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        guard let imageStr = _imageStr else {
            complete?(nil, nil, .none, nil)
            return
        }
        DispatchQueue.global().async {
            let imageUrl = URL(string: imageStr)
            self.sd_setImage(with: imageUrl, placeholderImage: placeholdImage, progress: downloadProgress) { image, error, cacheType, url in
                DispatchQueue.main.async {
                    self.image = image
                    complete?(image, error, cacheType, url)
                }
            }
        }
    }
    
    public func setCorner_ty(redius: CGFloat) {
        self.layer.cornerRadius  = redius
        self.layer.masksToBounds = true
    }
}
