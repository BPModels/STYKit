//
//  TYTableViewCell.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

open class TYTableViewCell: UITableViewCell {
    
    public struct Associated {
        static var lineView = "kLineView"
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.bindProperty_ty()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== TYBaseDelegate ====
    public func createSubviews_ty() {}
    public func bindProperty_ty() {
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: kScreenWidth_ty, bottom: 0, right: 0)
    }
    public func bindData_ty() {}
    public func updateUI_ty() {}
    
    public func setLine_ty(left: CGFloat = AdaptSize_ty(15), right: CGFloat = 0, isHide: Bool) {
        if let lineView = objc_getAssociatedObject(self, &Associated.lineView) as? UIView {
            lineView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(left)
                make.right.equalToSuperview().offset(right)
            }
            lineView.isHidden = isHide
        } else {
            let lineView = TYView()
            lineView.backgroundColor = UIColor.gray
            contentView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(left)
                make.right.equalToSuperview().offset(right)
                make.bottom.equalToSuperview()
                make.height.equalTo(0.5)
            }
            lineView.isHidden = isHide
            objc_setAssociatedObject(self, &Associated.lineView, lineView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
