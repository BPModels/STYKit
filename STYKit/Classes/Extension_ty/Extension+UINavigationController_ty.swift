//
//  Extension+UINavigationController.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Foundation

public extension UINavigationController {
    
    func containClass_ty(with_ty targetClass_ty: AnyClass) -> Bool {
        
        var isContain_ty = false
        for otherClass_ty in self.children {
            if otherClass_ty.classForCoder == targetClass_ty {
                isContain_ty = true
                break
            }
        }
        return isContain_ty
    }
    
    func push_ty(vc_ty: UIViewController, animation_ty: Bool = true) {
        self.pushViewController(vc_ty, animated: animation_ty)
        if self.children.count > 1 {
            vc_ty.hidesBottomBarWhenPushed = true
        }
    }
    
    func pop_ty(animation_ty: Bool = true) {
        self.popViewController(animated: animation_ty)
        if self.children.count <= 1 {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    func pop2VC_ty(taget_ty: AnyClass?) {
        var targetVC_ty: UIViewController?
        for vc_ty in self.children {
            if vc_ty.classForCoder == taget_ty {
                targetVC_ty = vc_ty
            }
        }
        if let vc_ty = targetVC_ty {
            self.popToViewController(vc_ty, animated: true)
        } else {
            self.pop_ty()
        }
        
    }
    
    func haveVC_ty(taget_ty: AnyClass) -> Bool {
        for vc_ty in self.children {
            if vc_ty.classForCoder == taget_ty {
                return true
            }
        }
        return false
    }
}
