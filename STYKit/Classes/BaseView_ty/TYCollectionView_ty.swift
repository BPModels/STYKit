//
//  TYCollectionView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import UIKit

public class TYCollectionView_ty: UICollectionView {
    
    /// 是否隐藏默认空页面
    public var isHideEmptyView_ty: Bool = false
    /// 为空占位图
    public var emptyImage_ty: UIImage?
    /// 为空文案
    public var emptyHintText_ty: String?
    
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
        if !self.isHideEmptyView_ty {
            let emptyView = TYEmptyView_ty()
            emptyView.setData_ty(image: self.emptyImage_ty, hintText: self.emptyHintText_ty)
            self.backgroundView = emptyView
        }
    }
}
