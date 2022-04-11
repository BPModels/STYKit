//
//  TYRedDotView.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public class TYRedDotView: TYView {
    
    public enum TYRedDotViewEnum {
        /// 红色背景
        case red
        /// 灰色背景
        case gray
        
        var backgroundColor: UIColor {
            switch self {
            case .red:
                return UIColor.red0
            case .gray:
                return UIColor.gray0
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .red:
                return UIColor.white
            case .gray:
                return UIColor.black
            }
        }
    }

    private var showNumber_ty: Bool
    private let maxNumber_ty: Int   = 99
    private var defaultH_ty:CGFloat = .zero
    private var colorType_ty: TYRedDotViewEnum = .red
    
    private let numLabel_ty: TYLabel = {
        let label = TYLabel()
        label.text          = ""
        label.font          = UIFont.custom_ty(.PingFangTCRegular, size: AdaptSize_ty(10))
        label.textAlignment = .center
        return label
    }()
    
    /// 是否显示未读数，false则显示红点
    /// - Parameter showNumber: 未读数量
    public init(showNumber: Bool = false, colorType: TYRedDotViewEnum = .red) {
        self.colorType_ty  = colorType
        self.showNumber_ty = showNumber
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
        self.backgroundColor    = colorType_ty.backgroundColor
        self.numLabel_ty.textColor = colorType_ty.titleColor
    }
    
    // MARK: ==== Event ====
    public func updateNumber_ty(_ num: Int) {
        let value          = self.getNumberStr_ty(num: num)
        self.numLabel_ty.text = value
        self.isHidden      = num <= 0
        // update layout
        if self.superview != nil {
            var w = defaultH_ty
            if (num > 9 || num < 0) {
                w = value.textWidth_ty(font: numLabel_ty.font, height: defaultH_ty) + AdaptSize_ty(10)
            }
            self.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize(width: w, height: defaultH_ty))
            }
        }
    }
    
    // TODO: ==== Tools ====
    public func getNumberStr_ty(num: Int) -> String {
        return num > maxNumber_ty ? "\(maxNumber_ty)+" : "\(num)"
    }
    
}
