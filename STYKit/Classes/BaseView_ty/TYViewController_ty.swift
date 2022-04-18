//
//  TYViewController_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

open class TYViewController_ty: UIViewController, TYNavigationBarDelegate_ty {
    
    private struct Associatoed_ty {
        static var customNavigationBar_ty = "customNavigationBar_ty"
    }
    
    public var customNavigationBar_ty: TYNavigationBar_ty? {
        return objc_getAssociatedObject(self, &Associatoed_ty.customNavigationBar_ty) as? TYNavigationBar_ty
    }
    
    open override var title: String? {
        willSet(newValue_ty) {
            self.customNavigationBar_ty?.title_ty = newValue_ty
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setCustomNavigationBar()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setCustomNavigationBar() {
        let nBar_ty = TYNavigationBar_ty()
        objc_setAssociatedObject(self, &Associatoed_ty.customNavigationBar_ty, nBar_ty, .OBJC_ASSOCIATION_RETAIN)
        self.view.addSubview(nBar_ty)
        nBar_ty.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kNavigationHeight_ty)
        }
        self.customNavigationBar_ty?.delegate_ty = self
    }
    
    open func createSubviews_ty() {}

    open func bindProperty_ty() {}

    open func bindData_ty() {}
    
    /// 更新UI颜色、图片
    open func updateUI_ty() {}

    open func registerNotification_ty() {}

    
    // MARK: ==== Event ====
    public func leftAction_ty() {
        self.view.endEditing(true)
        if let nav_ty = self.navigationController {
            nav_ty.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    public func rightAction_ty() {}
}
