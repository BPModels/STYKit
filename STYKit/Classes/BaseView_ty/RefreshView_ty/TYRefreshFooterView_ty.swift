//
//  TYRefreshFooterView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation

public class TYRefreshFooterView_ty: TYView_ty {
    
    public var iconView_ty: UIActivityIndicatorView = {
        let iconView_ty = UIActivityIndicatorView()
        iconView_ty.hidesWhenStopped = true
        iconView_ty.startAnimating()
        return iconView_ty
    }()
    
    public var titleLabel_ty: TYLabel_ty = {
        let label_ty = TYLabel_ty()
        label_ty.text          = ""
        label_ty.textColor     = UIColor.black0_ty
        label_ty.font          = UIFont.regular_ty(AdaptSize_ty(13))
        label_ty.textAlignment = .left
        label_ty.numberOfLines = 0
        return label_ty
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(iconView_ty)
        self.addSubview(titleLabel_ty)
        iconView_ty.snp.makeConstraints { (make_ty) in
            make_ty.width.equalTo(AdaptSize_ty(35))
            make_ty.height.equalTo(AdaptSize_ty(35))
            make_ty.right.equalTo(titleLabel_ty.snp.left).offset(AdaptSize_ty(-5))
            make_ty.centerY.equalTo(titleLabel_ty)
        }
        titleLabel_ty.snp.makeConstraints { make_ty in
            make_ty.centerX.equalToSuperview().offset(AdaptSize_ty(20))
            make_ty.bottom.equalToSuperview().offset(AdaptSize_ty(-8))
        }
    }
    
    public override func updateUI_ty() {
        super.updateUI_ty()
        self.iconView_ty.backgroundColor = .clear
        self.backgroundColor             = .clear
    }
    
    public func setStatus_ty(status_ty: BPRefreshStatus_ty) {
        switch status_ty {
        case .footerPulling_ty:
            self.titleLabel_ty.text = "上拉加载更多"
            self.iconView_ty.stopAnimating()
            self.titleLabel_ty.snp.updateConstraints { make_ty in
                make_ty.centerX.equalToSuperview()
            }
        case .footerPullMax_ty:
            self.titleLabel_ty.text = "松手开始加载"
            self.iconView_ty.stopAnimating()
            self.titleLabel_ty.snp.updateConstraints { make_ty in
                make_ty.centerX.equalToSuperview()
            }
        case .footerLoading_ty:
            self.titleLabel_ty.text = "加载中～"
            self.iconView_ty.startAnimating()
            self.titleLabel_ty.snp.updateConstraints { make_ty in
                make_ty.centerX.equalToSuperview().offset(AdaptSize_ty(20))
            }
        default:
            self.titleLabel_ty.text = ""
            self.iconView_ty.stopAnimating()
        }
    }
}
