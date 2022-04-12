//
//  Extension+PHAsset.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Photos
import UIKit

public extension PHAsset {
    /// 转换得到资源对象
    func toMediaImageModel_ty(progressBlock: DoubleBlock_ty?, completeBlock: ((TYMediaImageModel)->Void)?) {
        let options = PHImageRequestOptions()
        options.isSynchronous          = true
        options.resizeMode             = .fast
        options.isNetworkAccessAllowed = true
        options.deliveryMode           = .highQualityFormat
        options.progressHandler = { (progress, error, stop, userInfo:[AnyHashable : Any]?) in
            DispatchQueue.main.async {
                progressBlock?(progress)
            }
        }
        let model = TYMediaImageModel()
        let requestId: PHImageRequestID = PHCachingImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image: UIImage?, info:[AnyHashable : Any]?) in
            guard let result = info as? [String: Any], (result[PHImageCancelledKey] == nil), (result[PHImageErrorKey] == nil) else {
                return
            }
            
            model.image_ty = image
            completeBlock?(model)
        }
        model.id_ty = "\(requestId)"
    }
    
    func toMediaVideoModel_ty(progressBlock: DoubleBlock_ty?, completeBlock: ((TYMediaVideoModel)->Void)?) {
        
    }
}
