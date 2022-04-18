//
//  TYRedDotView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public class TYRedDotView_ty: TYView_ty {
    
    public enum TYRedDotViewEnum_ty {
        /// 红色背景
        case red_ty
        /// 灰色背景
        case gray_ty
        
        var backgroundColor_ty: UIColor {
            switch self {
            case .red_ty:
                return UIColor.red0_ty
            case .gray_ty:
                return UIColor.gray0_ty
            }
        }
        
        var titleColor_ty: UIColor {
            switch self {
            case .red_ty:
                return UIColor.white
            case .gray_ty:
                return UIColor.black
            }
        }
    }

    private var showNumber_ty: Bool
    private let maxNumber_ty: Int   = 99
    private var defaultH_ty:CGFloat = .zero
    private var colorType_ty: TYRedDotViewEnum_ty = .red_ty
    
    private let numLabel_ty: TYLabel_ty = {
        let label_ty = TYLabel_ty()
        label_ty.text          = ""
        label_ty.font          = UIFont.regular_ty(AdaptSize_ty(10))
        label_ty.textAlignment = .center
        return label_ty
    }()
    
    /// 是否显示未读数，false则显示红点
    /// - Parameter showNumber: 未读数量
    public init(showNumber_ty: Bool = false, colorType_ty: TYRedDotViewEnum_ty = .red_ty) {
        self.colorType_ty  = colorType_ty
        self.showNumber_ty = showNumber_ty
        super.init(frame: .zero)
        if showNumber_ty {
            defaultH_ty = AdaptSize_ty(16)
        } else {
            // 小圆点
            defaultH_ty  = AdaptSize_ty(6)
            self.size_ty = CGSize(width: defaultH_ty, height: defaultH_ty)
        }
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.updateUI_ty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews_ty() {
        super.createSubviews_ty()
        if showNumber_ty {
            self.addSubview(self.numLabel_ty)
            self.numLabel_ty.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.isUserInteractionEnabled = false
        self.layer.cornerRadius       = defaultH_ty/2
        if showNumber_ty {
            self.layer.borderColor  = UIColor.white.cgColor
            self.layer.borderWidth  = 1
        }
    }
    
    public override func updateUI_ty() {
        super.updateUI_ty()
        self.backgroundColor       = colorType_ty.backgroundColor_ty
        self.numLabel_ty.textColor = colorType_ty.titleColor_ty
    }
    
    // MARK: ==== Event ====
    public func updateNumber_ty(_ num_ty: Int) {
        let value_ty          = self.getNumberStr_ty(num_ty: num_ty)
        self.numLabel_ty.text = value_ty
        self.isHidden         = num_ty <= 0
        // update layout
        if self.superview != nil {
            var w_ty = defaultH_ty
            if (num_ty > 9 || num_ty < 0) {
                w_ty = value_ty.textWidth_ty(font_ty: numLabel_ty.font, height_ty: defaultH_ty) + AdaptSize_ty(10)
            }
            self.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize(width: w_ty, height: defaultH_ty))
            }
        }
    }
    
    // TODO: ==== Tools ====
    public func getNumberStr_ty(num_ty: Int) -> String {
        return num_ty > maxNumber_ty ? "\(maxNumber_ty)+" : "\(num_ty)"
    }
    
}
