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
        var rows     = 0
        let sections = numberOfSections
        for section in 0..<sections {
            rows += numberOfRows(inSection: section)
        }
        if (rows == 0 && sections == 0) || (rows == 0 && sections == 1 && headerView(forSection: 0) == nil && footerView(forSection: 0) == nil) {
            // 显示默认页面
            if let emptyView = emptyView_ty {
                self.backgroundView = emptyView
            }
        } else {
            // 隐藏默认页面
            self.backgroundColor = nil
        }
    }
}
