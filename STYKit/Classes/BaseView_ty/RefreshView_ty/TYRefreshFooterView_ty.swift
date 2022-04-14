//
//  TYRefreshFooterView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation

public class TYRefreshFooterView_ty: TYView_ty {
    
    public var iconView: UIActivityIndicatorView = {
        let iconView = UIActivityIndicatorView()
        iconView.hidesWhenStopped = true
        iconView.startAnimating()
        return iconView
    }()
    
    public var titleLabel: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = ""
        label.textColor     = UIColor.black0_ty
        label.font          = UIFont.regular_ty(size: AdaptSize_ty(13))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
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
        self.addSubview(iconView)
        self.addSubview(titleLabel)
        iconView.snp.makeConstraints { (make) in
            make.width.equalTo(AdaptSize_ty(35))
            make.height.equalTo(AdaptSize_ty(35))
            make.right.equalTo(titleLabel.snp.left).offset(AdaptSize_ty(-5))
            make.centerY.equalTo(titleLabel)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(AdaptSize_ty(20))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-8))
        }
    }
    
    public override func updateUI_ty() {
        super.updateUI_ty()
        self.iconView.backgroundColor = .clear
        self.backgroundColor          = .clear
    }
    
    public func setStatus(status: BPRefreshStatus) {
        switch status {
        case .footerPulling:
            self.titleLabel.text = "上拉加载更多"
            self.iconView.stopAnimating()
            self.titleLabel.snp.updateConstraints { make in
                make.centerX.equalToSuperview()
            }
        case .footerPullMax:
            self.titleLabel.text = "松手开始加载"
            self.iconView.stopAnimating()
            self.titleLabel.snp.updateConstraints { make in
                make.centerX.equalToSuperview()
            }
        case .footerLoading:
            self.titleLabel.text = "加载中～"
            self.iconView.startAnimating()
            self.titleLabel.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(AdaptSize_ty(20))
            }
        default:
            self.titleLabel.text = ""
            self.iconView.stopAnimating()
        }
    }
}
