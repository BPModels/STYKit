//
//  TYToastView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public class TYToastView_ty: TYView_ty {
    private let maxWidth_ty     = AdaptSize_ty(230)
    private let defaultWidth_ty = AdaptSize_ty(120)
    private let defaultHight_ty = AdaptSize_ty(70)
    
    private var descriptionLabel_ty: TYLabel_ty = {
        let label = TYLabel_ty()
        label.size_ty               = CGSize(width: AdaptSize_ty(100), height: AdaptSize_ty(50))
        label.text                  = ""
        label.textColor             = UIColor.white
        label.font                  = UIFont.medium_ty(size: AdaptSize_ty(14))
        label.textAlignment         = .center
        label.numberOfLines         = 0
        label.backgroundColor       = UIColor.black.withAlphaComponent(0.75)
        label.layer.cornerRadius    = AdaptSize_ty(5)
        label.layer.masksToBounds   = true
        return label
    }()
    
    init(message: String) {
        super.init(frame: .zero)
        self.descriptionLabel_ty.text = message
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func updateConstraints() {
        self.descriptionLabel_ty.sizeToFit()
        var _width = self.descriptionLabel_ty.width_ty + AdaptSize_ty(10)
        if _width > self.maxWidth_ty {
            _width = self.maxWidth_ty
        } else if _width < self.defaultWidth_ty {
            _width = self.defaultWidth_ty
        }
        var _size = self.descriptionLabel_ty.sizeThatFits(CGSize(width: _width, height: CGFloat(Int.max)))
        _size = CGSize(width: _size.width + AdaptSize_ty(10), height: _size.height + AdaptSize_ty(10))
        descriptionLabel_ty.snp.makeConstraints { make in
            make.size.equalTo(_size)
            make.center.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: ==== Event ====
    func show_ty(with present: UIView = kWindow_ty) {
        if descriptionLabel_ty.superview != nil {
            present.removeFromSuperview()
        }
        present.addSubview(descriptionLabel_ty)
        self.descriptionLabel_ty.layer.addJellyAnimation_ty()
        self.updateConstraints()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.descriptionLabel_ty.removeFromSuperview()
        }
    }
}

