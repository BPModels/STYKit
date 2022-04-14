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
    public func show_ty(complete block:(([TYMediaModel_ty])->Void)?, maxCount: Int = 1) {
        TYActionSheet_ty().addItem_ty(title: "相册", actionBlock: {
            TYPhotoManager_ty.share_ty.showPhoto_ty(complete: { (modelList) in
                block?(modelList)
            }, maxCount: maxCount)
        }).addItem_ty(title: "相机", actionBlock: {
            TYPhotoManager_ty.share_ty.showCamera_ty { (modelList) in
                block?(modelList)
            }
        }).show_ty()
    }
    
    /// 显示系统相机
    /// - Parameter block: 拍照后回调
    public func showCamera_ty(complete block:(([TYMediaModel_ty])->Void)?) {
        TYAuthorizationManager_ty.share_ty.camera_ty { [weak self] (result) in
            guard let self = self, result else { return }
            TYAuthorizationManager_ty.share_ty.photo_ty { [weak self] result in
                guard let self = self, result else { return }
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.completeBlock_ty = block
                    let vc = UIImagePickerController()
                    vc.delegate      = self
                    vc.allowsEditing = false
                    vc.sourceType    = .camera
                    currentVC_ty?.present(vc, animated: true, completion: nil)
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
    public func showPhoto_ty(complete block: (([TYMediaModel_ty])->Void)?, maxCount: Int = 1) {
        TYAuthorizationManager_ty.share_ty.photo_ty { (result) in
            guard result else { return }
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let vc = TYSystemPhotoViewController_ty()
                vc.maxSelectCount_ty = maxCount
                vc.selectedBlock_ty = { (medioModelList) in
                    block?(medioModelList)
                }
                if let nvc = currentNVC_ty {
                    nvc.push_ty(vc: vc)
                } else {
                    currentVC_ty?.present(vc, animated: true)
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
    public func showPhoto_ty(complete block: (([UIImage])->Void)?, maxCount: Int = 1, autoPop: Bool = true, push: Bool = true) {
        TYAuthorizationManager_ty.share_ty.photo_ty { (result) in
            let vc = TYSystemPhotoViewController_ty()
            vc.maxSelectCount_ty = maxCount
            vc.autoPop_ty        = autoPop
            vc.selectedBlock_ty  = { (medioModelList) in
                var imageList = [UIImage]()
                medioModelList.forEach { model in
                    if let imageModel = model as? TYMediaImageModel_ty, let _image = imageModel.image_ty {
                        imageList.append(_image)
                    }
                }
                block?(imageList)
            }
            if (push) {
                currentNVC_ty?.push_ty(vc: vc)
            } else {
                let controller = UINavigationController.init(rootViewController: vc)
                controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                currentVC_ty?.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: ==== UIImagePickerControllerDelegate, UINavigationControllerDelegate ====
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.completeBlock_ty?([])
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?
        if picker.allowsEditing {
            image = info[.editedImage] as? UIImage
        } else {
            image = info[.originalImage] as? UIImage
        }
        let model = TYMediaImageModel_ty()
        model.image_ty = image
        model.name_ty  = "\(Date().timeIntervalSince1970).JPG"
        self.completeBlock_ty?([model])
        if let _image = image {
            UIImageWriteToSavedPhotosAlbum(_image, nil, nil, nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
