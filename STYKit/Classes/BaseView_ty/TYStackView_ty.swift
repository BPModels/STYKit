//
//  TYStackView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public enum TYDirectionType_ty: Int {
    /// 左对齐
    case left
    /// 右对齐
    case right
    /// 顶部对齐
    case top
    /// 底部对齐
    case bottom
    /// 居中对齐
    case center
}

public class TYStackView_ty: TYView_ty {
    public var offsetX_ty: CGFloat = .zero
    public var offsetY_ty: CGFloat = .zero
    public var spacing_ty: CGFloat
    private var alignType_ty: TYDirectionType_ty
    private var subviewList_ty: [UIView]
    
    public init(type_ty: TYDirectionType_ty, subview_ty list_ty: [UIView] = [], spacing_ty: CGFloat = .zero) {
        self.alignType_ty   = type_ty
        self.subviewList_ty = list_ty
        self.spacing_ty     = spacing_ty
        super.init(frame: .zero)
        self.updateUI_ty()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func updateUI_ty() {
        super.updateUI_ty()
        self.backgroundColor = UIColor.clear
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard !subviewList_ty.isEmpty else { return }
        switch alignType_ty {
        case .left:
            offsetX_ty = 0
            for subview_ty in subviewList_ty {
                self.addSubview(subview_ty)
                subview_ty.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(offsetX_ty)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(subview_ty.size_ty)
                }
                offsetX_ty += (subview_ty.width_ty + spacing_ty)
            }
        case .center:
            offsetX_ty = 0
            var residueW_ty = self.width_ty
            subviewList_ty.forEach { (subview_ty) in
                residueW_ty -= subview_ty.width_ty
            }
            if spacing_ty.isZero {
                // 未设置间距
                self.spacing_ty = residueW_ty / CGFloat(subviewList_ty.count - 1)
            } else {
                // 固定间距
                residueW_ty -= CGFloat(subviewList_ty.count - 1) * spacing_ty
                offsetX_ty = residueW_ty / 2
            }
            for subview_ty in subviewList_ty {
                self.addSubview(subview_ty)
                subview_ty.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(offsetX_ty)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(subview_ty.size_ty)
                }
                offsetX_ty += (subview_ty.width_ty + spacing_ty)
            }
        case .right:
            offsetX_ty = 0
            let _subviewList_ty = subviewList_ty.reversed()
            for subview_ty in _subviewList_ty {
                self.addSubview(subview_ty)
                subview_ty.snp.remakeConstraints { (make) in
                    make.right.equalToSuperview().offset(offsetX_ty)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(subview_ty.size_ty)
                }
                offsetX_ty -= (subview_ty.width_ty + spacing_ty)
            }
        case .top:
            offsetY_ty = 0
            for subview_ty in subviewList_ty {
                self.addSubview(subview_ty)
                subview_ty.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview().offset(offsetY_ty)
                    make.centerX.equalToSuperview()
                    make.size.equalTo(subview_ty.size_ty)
                }
                offsetY_ty += (subview_ty.height_ty + spacing_ty)
            }
        default:
            break
        }
    }
    
    // MARK: ==== Event ====
    public func add_ty(view_ty: UIView) {
        self.subviewList_ty.append(view_ty)
        self.layoutSubviews()
    }
    
    public func insert_ty(view_ty: UIView, index_ty: Int) {
        if index_ty < 0 {
            self.subviewList_ty = [view_ty] + subviewList_ty
        } else if index_ty >= subviewList_ty.count {
            self.subviewList_ty.append(view_ty)
        } else {
            self.subviewList_ty.insert(view_ty, at: index_ty)
        }
        self.layoutSubviews()
    }
    
    public func remove_ty(view_ty: UIView) {
        for (index_ty, subview_ty) in subviewList_ty.enumerated() {
            if subview_ty == view_ty {
                subview_ty.removeFromSuperview()
                self.subviewList_ty.remove(at: index_ty)
                break
            }
        }
        self.layoutSubviews()
    }
    
    public func removeAll_ty() {
        self.subviewList_ty.forEach { (subview_ty) in
            subview_ty.removeFromSuperview()
        }
        self.subviewList_ty = []
        offsetX_ty = .zero
        offsetY_ty = .zero
    }
}
