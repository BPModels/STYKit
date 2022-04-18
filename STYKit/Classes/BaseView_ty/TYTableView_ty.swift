//
//  TYTableView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public class TYTableView_ty: UITableView {
    
    /// 指定为空的页面
    public var emptyView_ty: UIView?
    
    public override func reloadData() {
        super.reloadData()
        self.configEmpTYView_ty()
    }
    
    private func configEmpTYView_ty() {
        var rows_ty     = 0
        let sections_ty = numberOfSections
        for section_ty in 0..<sections_ty {
            rows_ty += numberOfRows(inSection: section_ty)
        }
        if (rows_ty == 0 && sections_ty == 0) || (rows_ty == 0 && sections_ty == 1 && headerView(forSection: 0) == nil && footerView(forSection: 0) == nil) {
            // 显示默认页面
            if let emptyView_ty = emptyView_ty {
                self.backgroundView = emptyView_ty
            }
        } else {
            // 隐藏默认页面
            self.backgroundColor = nil
        }
    }
}
