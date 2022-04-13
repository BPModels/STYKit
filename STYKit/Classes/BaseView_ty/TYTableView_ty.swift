//
//  TYTableView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

open class TYTableView_ty: UITableView {
    
    /// 是否隐藏默认为空页面
    public var isHideEmpTYView_ty = false
    public var emptyImage_ty: UIImage?
    public var emptyHintText_ty: String?
    
    open override func reloadData() {
        super.reloadData()
        self.configEmpTYView_ty()
    }
    
    private func configEmpTYView_ty() {
        var rows     = 0
        let sections = numberOfSections
        for section in 0..<sections {
            rows += numberOfRows(inSection: section)
        }
        if (rows == 0 && sections == 0) || (rows == 0 && sections == 1 && headerView(forSection: 0) == nil && footerView(forSection: 0) == nil) {
            // 显示默认页面
            if !self.isHideEmpTYView_ty {
                let empTYView_ty = TYEmptyView_ty()
                empTYView_ty.setData_ty(image: emptyImage_ty, hintText: emptyHintText_ty)
                self.backgroundView = empTYView_ty
            }
        } else {
            // 隐藏默认页面
            self.backgroundColor = nil
        }
    }
}

