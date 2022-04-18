//
//  TYProgressView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public class TYProgressView_ty: TYView_ty {
    
    public enum TYProgressType_ty: Int {
        /// 直线
        case line_ty
        /// 圆形
        case round_ty
    }
    private var type_ty: TYProgressType_ty
    private var lineWidth_ty: CGFloat
    
    private var progressLayer_ty = CAShapeLayer()
    
    /// lineWidth: 仅适用于非直线进度条
    public init(type_ty: TYProgressType_ty, size_ty: CGSize, lineWidth_ty: CGFloat = AdaptSize_ty(10)) {
        self.type_ty      = type_ty
        self.lineWidth_ty = lineWidth_ty
        super.init(frame: CGRect(origin: .zero, size: size_ty))
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews_ty() {
        super.createSubviews_ty()
        self.progressLayer_ty.frame = CGRect(origin: .zero, size: size_ty)
        switch type_ty {
            case .line_ty:
                self.drawLineShape_ty()
            case .round_ty:
                self.drawRoundShape_ty()
        }
    }
    
    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.backgroundColor = .clear
    }
    
    // MARK: ==== Event ====
    private func drawLineShape_ty() {
        let bottomLayer_ty             = CAShapeLayer()
        bottomLayer_ty.frame           = bounds
        bottomLayer_ty.backgroundColor = UIColor.gray.cgColor
        bottomLayer_ty.cornerRadius    = height_ty/2
        self.layer.addSublayer(bottomLayer_ty)
        
        progressLayer_ty.frame           = CGRect(x: 0, y: 0, width: 0, height: height_ty)
        progressLayer_ty.backgroundColor = UIColor.blue.cgColor
        progressLayer_ty.cornerRadius    = height_ty/2
        
        self.layer.addSublayer(progressLayer_ty)
    }
    
    private func drawRoundShape_ty() {
        let center_ty     = CGPoint(x: width_ty/2, y: height_ty/2)
        let radius_ty     = (width_ty - lineWidth_ty*2)/2
        let startAngle_ty = -CGFloat.pi/2
        let endAngle_ty   = CGFloat.pi*3/2
        let path_ty = UIBezierPath(arcCenter: center_ty, radius: radius_ty, startAngle: startAngle_ty, endAngle: endAngle_ty, clockwise: true)
        
        let bottomLayer_ty         = CAShapeLayer()
        bottomLayer_ty.path        = path_ty.cgPath
        bottomLayer_ty.frame       = bounds
        bottomLayer_ty.fillColor   = UIColor.clear.cgColor
        bottomLayer_ty.strokeColor = UIColor.clear.cgColor
        bottomLayer_ty.lineWidth   = lineWidth_ty
        self.layer.addSublayer(bottomLayer_ty)
        
        progressLayer_ty.path        = path_ty.cgPath
        progressLayer_ty.lineWidth   = lineWidth_ty
        progressLayer_ty.lineCap     = .round
        progressLayer_ty.fillColor   = UIColor.clear.cgColor
        progressLayer_ty.strokeColor = UIColor.blue.cgColor
        progressLayer_ty.strokeEnd   = 0
        self.layer.addSublayer(progressLayer_ty)
    }
    
    public func updateProgress_ty(progress_ty: CGFloat, duration_ty: TimeInterval = 0.25, complete_ty block_ty: DefaultBlock_ty? = nil) {
        UIView.animate(withDuration: duration_ty) { [weak self] in
            guard let self = self else { return }
            switch self.type_ty {
                case .line_ty:
                    self.progressLayer_ty.width_ty = self.width_ty * progress_ty
                case .round_ty:
                    self.progressLayer_ty.strokeEnd = progress_ty
            }
        } completion: { finished_ty in
            if finished_ty {
                block_ty?()
            }
        }
    }
}
