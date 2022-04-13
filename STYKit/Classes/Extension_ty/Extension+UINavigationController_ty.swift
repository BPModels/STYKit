//
//  Extension+UINavigationController.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Foundation

public extension UINavigationController {
    
    func containClass_ty(with targetClass: AnyClass) -> Bool {
        
        var isContain = false
        for otherClass in self.children {
            if otherClass.classForCoder == targetClass {
                isContain = true
                break
            }
        }
        return isContain
    }
    
    func push_ty(vc: UIViewController, animation: Bool = true) {
        self.pushViewController(vc, animated: animation)
        if self.children.count > 1 {
            vc.hidesBottomBarWhenPushed = true
        }
    }
    
    func pop_ty(animation: Bool = true) {
        self.popViewController(animated: animation)
        if self.children.count <= 1 {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    func pop2VC_ty(taget: AnyClass?) {
        var targetVC: UIViewController?
        for vc in self.children {
            if vc.classForCoder == taget {
                targetVC = vc
            }
        }
        if let vc = targetVC {
            self.popToViewController(vc, animated: true)
        } else {
            self.pop_ty()
        }
        
    }
    
    func haveVC_ty(taget: AnyClass) -> Bool {
        for vc in self.children {
            if vc.classForCoder == taget {
                return true
            }
        }
        return false
    }
}
