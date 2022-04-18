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
    if let _window_ty = UIApplication.shared.keyWindow {
        return _window_ty
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
    var _height_ty = UIApplication.shared.statusBarFrame.size.height
    if #available(iOS 13, *) {
        if let _statusHeight_ty = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height {
            _height_ty = _statusHeight_ty
        }
    }
    return _height_ty
}()
/// 顶部导航栏高度
public let kNavigationHeight_ty = kStatusBarHeight_ty + 44.0
/// 底部安全高度
@available(iOS 11.0, *)
public let kSafeBottomMargin_ty = kWindow_ty.safeAreaInsets.bottom

public func AdaptSize_ty(_ size_ty: CGFloat) -> CGFloat {
    let newSize_ty = kScreenWidth_ty / (isPad_ty ? 768 : 375) * size_ty
    return newSize_ty
}

/// 当前NVC
public var currentNVC_ty: UINavigationController? {
    return currentVC_ty?.navigationController
}

/// 当前VC
public var currentVC_ty: UIViewController? {
    var rootViewController_ty: UIViewController?
    let textEffectsWindowClass_ty: AnyClass? = NSClassFromString("UITextEffectsWindow")
    for window_ty in UIApplication.shared.windows where !window_ty.isHidden {
        if let _textEffectsWindowClass_ty = textEffectsWindowClass_ty, window_ty.isKind(of: _textEffectsWindowClass_ty) { continue }
        if let windowRootViewController_ty = window_ty.rootViewController {
            rootViewController_ty = windowRootViewController_ty
            break
        }
    }
    var isFind_ty = false
    while !isFind_ty {
        // presented view controller
        if let presentedViewController_ty = rootViewController_ty?.presentedViewController {
            rootViewController_ty = presentedViewController_ty
            continue
        }
        // UITabBarController
        if let tabBarController_ty = rootViewController_ty as? UITabBarController,
            let selectedViewController_ty = tabBarController_ty.selectedViewController {
            rootViewController_ty = selectedViewController_ty
            continue
        }
        // UINavigationController
        if let navigationController_ty = rootViewController_ty as? UINavigationController,
            let visibleViewController_ty = navigationController_ty.visibleViewController {
            rootViewController_ty = visibleViewController_ty
            continue
        }
        // UIPageController
        if let pageViewController_ty = rootViewController_ty as? UIPageViewController,
            pageViewController_ty.viewControllers?.count == 1 {
            rootViewController_ty = pageViewController_ty.viewControllers?.first
            continue
        }
        // child view controller
        for subview_ty in rootViewController_ty?.view?.subviews ?? [] {
            if let childViewController_ty = subview_ty.next as? UIViewController {
                rootViewController_ty = childViewController_ty
                continue
            }
        }
        isFind_ty = true
    }
    return rootViewController_ty
}

/// 发送日志到钉钉
/// - Parameter content: 内容
public func sendLog_ty(_ content_ty: String) {
    let projectName_ty  = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "NULL"
    guard let url_ty = URL(string: "https://oapi.dingtalk.com/robot/send?access_token=ce9a301a2ecf61146066a9bdf0e1f8795e86e69a7085c58e78bcdb86204dd93e") else {
        return
    }
    let json_ty = ["msgtype": "text","text": ["content":"【\(projectName_ty)】通知：\(content_ty)"]].toJson_ty()
    var request_ty = URLRequest(url: url_ty)
    request_ty.httpMethod = "POST"
    request_ty.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    request_ty.httpBody = json_ty.data(using: .utf8)
    let task_ty = URLSession.shared.dataTask(with: request_ty)
    task_ty.resume()
}
