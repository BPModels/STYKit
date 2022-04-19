//
//  TYTableViewCell_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

open class TYTableViewCell_ty: UITableViewCell {
    
    open var indexPath: IndexPath?
    
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
    open func createSubviews_ty() {}
    open func bindProperty_ty() {
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: kScreenWidth_ty, bottom: 0, right: 0)
    }
    open func bindData_ty() {}
    open func updateUI_ty() {}
    open func registerNotification_ty() {}
    
    open func setLine_ty(left_ty: CGFloat = AdaptSize_ty(15), right_ty: CGFloat = 0, isHide_ty: Bool = false) {
        if let lineView_ty = objc_getAssociatedObject(self, &Associated_ty.lineView_ty) as? UIView {
            lineView_ty.snp.updateConstraints { make_ty in
                make_ty.left.equalToSuperview().offset(left_ty)
                make_ty.right.equalToSuperview().offset(right_ty)
            }
            lineView_ty.isHidden = isHide_ty
        } else {
            let lineView_ty = TYView_ty()
            lineView_ty.backgroundColor = UIColor.gray
            contentView.addSubview(lineView_ty)
            lineView_ty.snp.makeConstraints { make_ty in
                make_ty.left.equalToSuperview().offset(left_ty)
                make_ty.right.equalToSuperview().offset(right_ty)
                make_ty.bottom.equalToSuperview()
                make_ty.height.equalTo(0.5)
            }
            lineView_ty.isHidden = isHide_ty
            objc_setAssociatedObject(self, &Associated_ty.lineView_ty, lineView_ty, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
