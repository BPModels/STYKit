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
        let label_ty = TYLabel_ty()
        label_ty.size_ty               = CGSize(width: AdaptSize_ty(100), height: AdaptSize_ty(50))
        label_ty.text                  = ""
        label_ty.textColor             = UIColor.white
        label_ty.font                  = UIFont.medium_ty(AdaptSize_ty(14))
        label_ty.textAlignment         = .center
        label_ty.numberOfLines         = 0
        label_ty.backgroundColor       = UIColor.black.withAlphaComponent(0.75)
        label_ty.layer.cornerRadius    = AdaptSize_ty(5)
        label_ty.layer.masksToBounds   = true
        return label_ty
    }()
    
    init(_ message_ty: String) {
        super.init(frame: .zero)
        self.descriptionLabel_ty.text = message_ty
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
        descriptionLabel_ty.snp.makeConstraints { make_ty in
            make_ty.size.equalTo(_size)
            make_ty.center.equalToSuperview()
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

