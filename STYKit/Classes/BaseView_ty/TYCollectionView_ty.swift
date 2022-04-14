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
        var rows      = 0
        let sesctions = numberOfSections
        for section in 0..<sesctions {
            rows += numberOfItems(inSection: section)
        }
        let headerView = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))
        let footerView = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: 0))
        guard (rows == 0 && sesctions == 0) || (rows == 0 && sesctions == 1 && headerView == nil && footerView == nil) else {
            self.backgroundView = nil
            return
        }
        if (rows == 0 && sesctions == 0) || (rows == 0 && sesctions == 1 && headerView == nil && footerView == nil) {
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
