//
//  Extension+NSTextAttachment_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/19.
//

import Foundation

public extension NSTextAttachment {
    
    private struct AssociatedKeys_ty {
        static var name_ty = "kNSTextAttachmentName_ty"
    }
    
    /// 名称（暂用于表情名称）
    var name_ty: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.name_ty) as? String
        }
        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.name_ty, newValue_ty, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
