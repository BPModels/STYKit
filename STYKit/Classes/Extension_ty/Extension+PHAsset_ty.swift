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
    func toMediaImageModel_ty(progressBlock_ty: DoubleBlock_ty?, completeBlock_ty: ((TYMediaImageModel_ty)->Void)?) {
        let options_ty = PHImageRequestOptions()
        options_ty.isSynchronous          = true
        options_ty.resizeMode             = .fast
        options_ty.isNetworkAccessAllowed = true
        options_ty.deliveryMode           = .highQualityFormat
        options_ty.progressHandler = { (progress_ty, error_ty, stop_ty, userInfo_ty:[AnyHashable : Any]?) in
            DispatchQueue.main.async {
                progressBlock_ty?(progress_ty)
            }
        }
        let model_ty = TYMediaImageModel_ty()
        let requestId_ty: PHImageRequestID = PHCachingImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options_ty) { (image_ty: UIImage?, info_ty:[AnyHashable : Any]?) in
            guard let result_ty = info_ty as? [String: Any], (result_ty[PHImageCancelledKey] == nil), (result_ty[PHImageErrorKey] == nil) else {
                return
            }
            
            model_ty.image_ty = image_ty
            completeBlock_ty?(model_ty)
        }
        model_ty.id_ty = "\(requestId_ty)"
    }
    
    func toMediaVideoModel_ty(progressBlock_ty: DoubleBlock_ty?, completeBlock_ty: ((TYMediaVideoModel_ty)->Void)?) {
        
    }
}
