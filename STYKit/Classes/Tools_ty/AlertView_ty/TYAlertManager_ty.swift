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
        guard let alertView_ty = self.alertArray_ty.first else {
            return
        }
        // 关闭弹框后的闭包
        alertView_ty.closeActionBlock_ty = { [weak self] in
            guard let self = self else { return }
            self.isShowing_ty = false
            self.removeAlert_ty()
        }
        alertView_ty.show_ty()
    }

    /// 添加一个alertView
    /// - Parameter alertView: alert对象
    public func addAlert_ty(alertView_ty: TYBaseAlertView_ty) {
        self.alertArray_ty.append(alertView_ty)
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
    public func oneButton_ty(title_ty: String?, description_ty: String, buttonName_ty: String, closure_ty: (() -> Void)?) -> TYBaseAlertView_ty {
        let alertView_ty = KFAlertViewOneButton_ty(title_ty: title_ty, description_ty: description_ty, buttonName_ty: buttonName_ty, closure_ty: closure_ty)
        self.addAlert_ty(alertView_ty: alertView_ty)
        return alertView_ty
    }
    
    /// 显示底部两个按钮的弹框
    public func twoButton_ty(title_ty: String?, description_ty: String, leftBtnName_ty: String, leftBtnClosure_ty: (() -> Void)?, rightBtnName_ty: String, rightBtnClosure_ty: (() -> Void)?, isDestruct_ty: Bool = false) -> TYBaseAlertView_ty {
        let alertView_ty = TYAlertViewTwoButton_ty(title_ty: title_ty, description_ty: description_ty, leftBtnName_ty: leftBtnName_ty, leftBtnClosure_ty: leftBtnClosure_ty, rightBtnName_ty: rightBtnName_ty, rightBtnClosure_ty: rightBtnClosure_ty, isDestruct_ty: isDestruct_ty)
        self.addAlert_ty(alertView_ty: alertView_ty)
        return alertView_ty
    }
}
