//
//  TYGlobal.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

/// 默认闭包
public typealias DefaultBlock_ty   = (()->Void)
public typealias ImageBlock_ty     = ((UIImage?)->Void)
public typealias StringBlock_ty    = ((String)->Void)
public typealias BoolBlock_ty      = ((Bool)->Void)
public typealias DataBlock_ty      = ((Data?)->Void)
public typealias FloatBlock_ty     = ((Float)->Void)
public typealias DoubleBlock_ty    = ((Double?)->Void)
public typealias CGFloatBlock_ty   = ((CGFloat)->Void)
public typealias IntBlock_ty       = ((Int)->Void)
public typealias IndexPathBlock_ty = ((IndexPath)->Void)

public let isPad_ty = UIDevice.current.userInterfaceIdiom == .pad

public let kWindow_ty: UIWindow = {
    if let _window = UIApplication.shared.keyWindow {
        return _window
    } else {
        return UIWindow(frame: .zero)
    }
}()

/// 屏幕宽
public let kScreenWidth_ty  = UIScreen.main.bounds.size.width
/// 屏幕高
public let kScreenHeight_ty = UIScreen.main.bounds.size.height
///状态栏高度
public let kStatusBarHeight_ty: CGFloat = {
    var _height = UIApplication.shared.statusBarFrame.size.height
    if #available(iOS 13, *) {
        if let _statusHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height {
            _height = _statusHeight
        }
    }
    return _height
}()
/// 顶部导航栏高度
public let kNavigationHeight_ty = kStatusBarHeight_ty + 44.0
/// 底部安全高度
@available(iOS 11.0, *)
public let kSafeBottomMargin_ty = kWindow_ty.safeAreaInsets.bottom

public func AdaptSize_ty(_ size: CGFloat) -> CGFloat {
    let newSize = kScreenWidth_ty / (isPad_ty ? 768 : 375) * size
    return newSize
}

/// 当前VC
public var currentVC_ty: UIViewController? {
    var rootViewController: UIViewController?
    let textEffectsWindowClass: AnyClass? = NSClassFromString("UITextEffectsWindow")
    for window in UIApplication.shared.windows where !window.isHidden {
        if let _textEffectsWindowClass = textEffectsWindowClass, window.isKind(of: _textEffectsWindowClass) { continue }
        if let windowRootViewController = window.rootViewController {
            rootViewController = windowRootViewController
            break
        }
    }
    var isFind = false
    while !isFind {
        // presented view controller
        if let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
            continue
        }
        // UITabBarController
        if let tabBarController = rootViewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            rootViewController = selectedViewController
            continue
        }
        // UINavigationController
        if let navigationController = rootViewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            rootViewController = visibleViewController
            continue
        }
        // UIPageController
        if let pageViewController = rootViewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            rootViewController = pageViewController.viewControllers?.first
            continue
        }
        // child view controller
        for subview in rootViewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                rootViewController = childViewController
                continue
            }
        }
        isFind = true
    }
    return rootViewController
}


