//
//  TYCollectionView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import UIKit

public class TYCollectionView_ty: UICollectionView {
    
    /// 指定为空的页面
    public var emptyView_ty: UIView?
    
    public override func reloadData() {
        super.reloadData()
        self.configEmptyView_ty()
    }
    
    /// 配置默认空页面
    private func configEmptyView_ty() {
        var rows_ty      = 0
        let sesctions_ty = numberOfSections
        for section_ty in 0..<sesctions_ty {
            rows_ty += numberOfItems(inSection: section_ty)
        }
        let headerView_ty = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))
        let footerView_ty = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: 0))
        guard (rows_ty == 0 && sesctions_ty == 0) || (rows_ty == 0 && sesctions_ty == 1 && headerView_ty == nil && footerView_ty == nil) else {
            self.backgroundView = nil
            return
        }
        if (rows_ty == 0 && sesctions_ty == 0) || (rows_ty == 0 && sesctions_ty == 1 && headerView_ty == nil && footerView_ty == nil) {
            // 显示默认页面
            if let _emptyView_ty = emptyView_ty {
                self.backgroundView = _emptyView_ty
            }
        } else {
            // 隐藏默认页面
            self.backgroundColor = nil
        }
    }
}
