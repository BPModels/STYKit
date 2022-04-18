//
//  TYTableViewCell_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public class TYTableViewCell_ty: UITableViewCell {
    
    public struct Associated_ty {
        static var lineView_ty = "kLineView_ty"
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.bindProperty_ty()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== TYBaseDelegate_ty ====
    public func createSubviews_ty() {}
    public func bindProperty_ty() {
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: kScreenWidth_ty, bottom: 0, right: 0)
    }
    public func bindData_ty() {}
    public func updateUI_ty() {}
    
    public func setLine_ty(left_ty: CGFloat = AdaptSize_ty(15), right_ty: CGFloat = 0, isHide_ty: Bool) {
        if let lineView_ty = objc_getAssociatedObject(self, &Associated_ty.lineView_ty) as? UIView {
            lineView_ty.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(left_ty)
                make.right.equalToSuperview().offset(right_ty)
            }
            lineView_ty.isHidden = isHide_ty
        } else {
            let lineView_ty = TYView_ty()
            lineView_ty.backgroundColor = UIColor.gray
            contentView.addSubview(lineView_ty)
            lineView_ty.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(left_ty)
                make.right.equalToSuperview().offset(right_ty)
                make.bottom.equalToSuperview()
                make.height.equalTo(0.5)
            }
            lineView_ty.isHidden = isHide_ty
            objc_setAssociatedObject(self, &Associated_ty.lineView_ty, lineView_ty, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
