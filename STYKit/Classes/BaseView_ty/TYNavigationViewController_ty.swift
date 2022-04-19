//
//  TYNavigationViewController_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/19.
//

import Foundation

open class TYNavigationController_ty: UINavigationController, UIGestureRecognizerDelegate {
    
    /// 浅色状态栏样式
    private let lightStatusBarVCList_ty: [AnyClass] = []

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: ==== Override ====
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        self.setNavigationBarHidden(true, animated: false)
        super.pushViewController(viewController, animated: animated)
    }
    
    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        self.setNavigationBarHidden(true, animated: false)
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topVC_ty = self.children.last, lightStatusBarVCList_ty.contains(where: { (targetType_ty) -> Bool in
            return topVC_ty.classForCoder == targetType_ty
        }) else {
            return .default
        }
        return .lightContent
    }
    
    open override var childForStatusBarHidden: UIViewController?{
        return self.topViewController
    }
    open override var childForStatusBarStyle: UIViewController?{
        return self.topViewController
    }
}
