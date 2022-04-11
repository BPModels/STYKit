//
//  TYStackView.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public enum TYDirectionType: Int {
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

open class TYStackView: TYView {
    public var offsetX_ty: CGFloat = .zero
    public var offsetY_ty: CGFloat = .zero
    public var spacing_ty: CGFloat
    private var alignType_ty: TYDirectionType
    private var subviewList_ty: [UIView]
    
    public init(type: TYDirectionType, subview list: [UIView] = [], spacing: CGFloat = .zero) {
        self.alignType_ty   = type
        self.subviewList_ty = list
        self.spacing_ty     = spacing
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
            for subview in subviewList_ty {
                self.addSubview(subview)
                subview.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(offsetX_ty)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(subview.size_ty)
                }
                offsetX_ty += (subview.width_ty + spacing_ty)
            }
        case .center:
            offsetX_ty = 0
            var residueW = self.width_ty
            subviewList_ty.forEach { (subview) in
                residueW -= subview.width_ty
            }
            if spacing_ty.isZero {
                // 未设置间距
                self.spacing_ty = residueW / CGFloat(subviewList_ty.count - 1)
            } else {
                // 固定间距
                residueW -= CGFloat(subviewList_ty.count - 1) * spacing_ty
                offsetX_ty = residueW / 2
            }
            for subview in subviewList_ty {
                self.addSubview(subview)
                subview.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(offsetX_ty)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(subview.size_ty)
                }
                offsetX_ty += (subview.width_ty + spacing_ty)
            }
        case .right:
            offsetX_ty = 0
            let _subviewList_ty = subviewList_ty.reversed()
            for subview in _subviewList_ty {
                self.addSubview(subview)
                subview.snp.remakeConstraints { (make) in
                    make.right.equalToSuperview().offset(offsetX_ty)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(subview.size_ty)
                }
                offsetX_ty -= (subview.width_ty + spacing_ty)
            }
        case .top:
            offsetY_ty = 0
            for subview in subviewList_ty {
                self.addSubview(subview)
                subview.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview().offset(offsetY_ty)
                    make.centerX.equalToSuperview()
                    make.size.equalTo(subview.size_ty)
                }
                offsetY_ty += (subview.height_ty + spacing_ty)
            }
        default:
            break
        }
    }
    
    // MARK: ==== Event ====
    public func add(view: UIView) {
        self.subviewList_ty.append(view)
        self.layoutSubviews()
    }
    
    public func insert(view: UIView, index: Int) {
        if index < 0 {
            self.subviewList_ty = [view] + subviewList_ty
        } else if index >= subviewList_ty.count {
            self.subviewList_ty.append(view)
        } else {
            self.subviewList_ty.insert(view, at: index)
        }
        self.layoutSubviews()
    }
    
    public func remove(view: UIView) {
        for (index, subview) in subviewList_ty.enumerated() {
            if subview == view {
                subview.removeFromSuperview()
                self.subviewList_ty.remove(at: index)
                break
            }
        }
        self.layoutSubviews()
    }
    
    public func removeAll() {
        self.subviewList_ty.forEach { (subview) in
            subview.removeFromSuperview()
        }
        self.subviewList_ty = []
        offsetX_ty = .zero
        offsetY_ty = .zero
    }
}
