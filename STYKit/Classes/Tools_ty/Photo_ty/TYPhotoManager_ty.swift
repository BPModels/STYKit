//
//  TYPhotoManager_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public class TYPhotoManager_ty: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc public static let share_ty = TYPhotoManager_ty()
    /// 系统相机的拍照后的回调使用
    private var completeBlock_ty: (([TYMediaModel_ty])->Void)?
    
    /// 显示选择相机还是相册
    /// - Parameters:
    ///   - block: 选择后的回调
    ///   - maxCount: 最大选择数量
    public func show_ty(complete_ty block_ty:(([TYMediaModel_ty])->Void)?, maxCount_ty: Int = 1) {
        TYActionSheet_ty().addItem_ty(title_ty: "相册", actionBlock_ty: {
            TYPhotoManager_ty.share_ty.showPhoto_ty(complete_ty: { (modelList) in
                block_ty?(modelList)
            }, maxCount_ty: maxCount_ty)
        }).addItem_ty(title_ty: "相机", actionBlock_ty: {
            TYPhotoManager_ty.share_ty.showCamera_ty { (modelList) in
                block_ty?(modelList)
            }
        }).show_ty()
    }
    
    /// 显示系统相机
    /// - Parameter block: 拍照后回调
    public func showCamera_ty(complete_ty block_ty:(([TYMediaModel_ty])->Void)?) {
        TYAuthorizationManager_ty.share_ty.camera_ty { [weak self] (result_ty) in
            guard let self = self, result_ty else { return }
            TYAuthorizationManager_ty.share_ty.photo_ty { [weak self] result_ty in
                guard let self = self, result_ty else { return }
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.completeBlock_ty = block_ty
                    let vc_ty = UIImagePickerController()
                    vc_ty.delegate      = self
                    vc_ty.allowsEditing = false
                    vc_ty.sourceType    = .camera
                    currentVC_ty?.present(vc_ty, animated: true, completion: nil)
                } else {
                    kWindow_ty.toast_ty("该设备不支持拍摄功能")
                }
            }
        }
    }
    
    /// 显示系统相册
    /// - Parameters:
    ///   - block: 选择后的回调
    ///   - maxCount: 最大选择数量
    public func showPhoto_ty(complete_ty block_ty: (([TYMediaModel_ty])->Void)?, maxCount_ty: Int = 1) {
        TYAuthorizationManager_ty.share_ty.photo_ty { (result_ty) in
            guard result_ty else { return }
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let vc_ty = TYSystemPhotoViewController_ty()
                vc_ty.maxSelectCount_ty = maxCount_ty
                vc_ty.selectedBlock_ty = { (medioModelList_ty) in
                    block_ty?(medioModelList_ty)
                }
                if let nvc_ty = currentNVC_ty {
                    nvc_ty.push_ty(vc_ty: vc_ty)
                } else {
                    currentVC_ty?.present(vc_ty, animated: true)
                }
            } else {
                kWindow_ty.toast_ty("该设备不支持相册功能")
            }
        }
    }

    /// 显示系统相册，----- (主要供OC调用) -----
    /// - Parameters:
    ///   - block: 选择后的回调
    ///   - maxCount: 最大选择数量
    @objc
    public func showPhoto_ty(complete_ty block_ty: (([UIImage])->Void)?, maxCount_ty: Int = 1, autoPop_ty: Bool = true, push_ty: Bool = true) {
        TYAuthorizationManager_ty.share_ty.photo_ty { (result_ty) in
            let vc_ty = TYSystemPhotoViewController_ty()
            vc_ty.maxSelectCount_ty = maxCount_ty
            vc_ty.autoPop_ty        = autoPop_ty
            vc_ty.selectedBlock_ty  = { (medioModelList_ty) in
                var imageList_ty = [UIImage]()
                medioModelList_ty.forEach { model_ty in
                    if let imageModel_ty = model_ty as? TYMediaImageModel_ty, let _image_ty = imageModel_ty.image_ty {
                        imageList_ty.append(_image_ty)
                    }
                }
                block_ty?(imageList_ty)
            }
            if (push_ty) {
                currentNVC_ty?.push_ty(vc_ty: vc_ty)
            } else {
                let controller_ty = UINavigationController.init(rootViewController: vc_ty)
                controller_ty.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                currentVC_ty?.present(controller_ty, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: ==== UIImagePickerControllerDelegate, UINavigationControllerDelegate ====
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.completeBlock_ty?([])
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image_ty: UIImage?
        if picker.allowsEditing {
            image_ty = info[.editedImage] as? UIImage
        } else {
            image_ty = info[.originalImage] as? UIImage
        }
        let model_ty = TYMediaImageModel_ty()
        model_ty.image_ty = image_ty
        model_ty.name_ty  = "\(Date().timeIntervalSince1970).JPG"
        self.completeBlock_ty?([model_ty])
        if let _image_ty = image_ty {
            UIImageWriteToSavedPhotosAlbum(_image_ty, nil, nil, nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
