//
//  TYView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public protocol TYBaseDelegate_ty: NSObjectProtocol {
    /// 初始化子视图
    func createSubviews_ty()
    /// 初始化属性
    func bindProperty_ty()
    /// 初始化数据
    func bindData_ty()
    /// 更新UI
    func updateUI_ty()
    /// 注册通知
    func registerNotification_ty()
}

open class TYView_ty: UIView, TYBaseDelegate_ty {
    deinit {
        #if DEBUG
        print("\(self.classForCoder): 释放")
        #endif
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.updateUI_ty()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== TYBaseDelegate_ty ====
    public func createSubviews_ty() {}
    public func bindProperty_ty() {}
    public func bindData_ty() {}
    public func updateUI_ty() {}
    public func registerNotification_ty() {}
}
