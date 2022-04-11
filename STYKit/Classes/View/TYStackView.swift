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
    public var offsetX: CGFloat = .zero
    public var offsetY: CGFloat = .zero
    public var spacing: CGFloat
    private var alignType: TYDirectionType
    private var subviewList: [UIView]
    
    public init(type: TYDirectionType, subview list: [UIView] = [], spacing: CGFloat = .zero) {
        self.alignType    = type
        self.subviewList  = list
        self.spacing      = spacing
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
        guard !subviewList.isEmpty else { return }
        switch alignType {
            case .left:
                offsetX = 0
                for subview in subviewList {
                    self.addSubview(subview)
                    subview.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().offset(offsetX)
                        make.centerY.equalToSuperview()
                        make.size.equalTo(subview.size_ty)
                    }
                    offsetX += (subview.width_ty + spacing)
                }
            case .center:
                offsetX = 0
                var residueW = self.width_ty
                subviewList.forEach { (subview) in
                    residueW -= subview.width_ty
                }
                if spacing.isZero {
                    // 未设置间距
                    self.spacing = residueW / CGFloat(subviewList.count - 1)
                } else {
                    // 固定间距
                    residueW -= CGFloat(subviewList.count - 1) * spacing
                    offsetX = residueW / 2
                }
                for subview in subviewList {
                    self.addSubview(subview)
                    subview.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().offset(offsetX)
                        make.centerY.equalToSuperview()
                        make.size.equalTo(subview.size_ty)
                    }
                    offsetX += (subview.width_ty + spacing)
                }
            case .right:
                offsetX = 0
                let _subviewList = subviewList.reversed()
                for subview in _subviewList {
                    self.addSubview(subview)
                    subview.snp.remakeConstraints { (make) in
                        make.right.equalToSuperview().offset(offsetX)
                        make.centerY.equalToSuperview()
                        make.size.equalTo(subview.size_ty)
                    }
                    offsetX -= (subview.width_ty + spacing)
                }
            case .top:
                offsetY = 0
                for subview in subviewList {
                    self.addSubview(subview)
                    subview.snp.remakeConstraints { (make) in
                        make.top.equalToSuperview().offset(offsetY)
                        make.centerX.equalToSuperview()
                        make.size.equalTo(subview.size_ty)
                    }
                    offsetY += (subview.height_ty + spacing)
                }
            default:
                break
        }
    }
    
    // MARK: ==== Event ====
    public func add(view: UIView) {
        self.subviewList.append(view)
        self.layoutSubviews()
    }
    
    public func insert(view: UIView, index: Int) {
        if index < 0 {
            self.subviewList = [view] + subviewList
        } else if index >= subviewList.count {
            self.subviewList.append(view)
        } else {
            self.subviewList.insert(view, at: index)
        }
        self.layoutSubviews()
    }
    
    public func remove(view: UIView) {
        for (index, subview) in subviewList.enumerated() {
            if subview == view {
                subview.removeFromSuperview()
                self.subviewList.remove(at: index)
                break
            }
        }
        self.layoutSubviews()
    }
    
    public func removeAll() {
        self.subviewList.forEach { (subview) in
            subview.removeFromSuperview()
        }
        self.subviewList = []
        offsetX = .zero
        offsetY = .zero
    }
}
