//
//  TYAlertManager_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public class TYAlertManager_ty {
    
    public static var share_ty = TYAlertManager_ty()
    private var alertArray_ty  = [TYBaseAlertView_ty]()
    private var isShowing_ty   = false
    
    public func show_ty() {
        guard !self.isShowing_ty else {
            return
        }
        self.isShowing_ty = true
        // 排序
        self.alertArray_ty.sort(by: { $0.priority_ty.rawValue < $1.priority_ty.rawValue })
        guard let alertView = self.alertArray_ty.first else {
            return
        }
        // 关闭弹框后的闭包
        alertView.closeActionBlock_ty = { [weak self] in
            guard let self = self else { return }
            self.isShowing_ty = false
            self.removeAlert_ty()
        }
        alertView.show_ty()
    }

    /// 添加一个alertView
    /// - Parameter alertView: alert对象
    public func addAlert_ty(alertView: TYBaseAlertView_ty) {
        self.alertArray_ty.append(alertView)
    }

    /// 移除当前已显示的Alert
    public func removeAlert_ty() {
        guard !self.alertArray_ty.isEmpty else {
            return
        }
        self.alertArray_ty.removeFirst()
        // 如果队列中还有未显示的Alert，则继续显示
        guard !self.alertArray_ty.isEmpty else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.show_ty()
        }
    }
    
    // MARK: ==== Alert view ====
    
    /// 显示底部一个按钮的弹框， 默认内容居中
    @discardableResult
    public func oneButton_ty(title: String?, description: String, buttonName: String, closure: (() -> Void)?) -> TYBaseAlertView_ty {
        let alertView = KFAlertViewOneButton_ty(title: title, description: description, buttonName: buttonName, closure: closure)
        self.addAlert_ty(alertView: alertView)
        return alertView
    }
    
    /// 显示底部两个按钮的弹框
    public func twoButton_ty(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?, isDestruct: Bool = false) -> TYBaseAlertView_ty {
        let alertView = TYAlertViewTwoButton_ty(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure, isDestruct: isDestruct)
        self.addAlert_ty(alertView: alertView)
        return alertView
    }
}
