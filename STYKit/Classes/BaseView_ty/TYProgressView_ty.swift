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
        case line
        /// 圆形
        case round
    }
    private var type_ty: TYProgressType_ty
    private var lineWidth_ty: CGFloat
    
    private var progressLayer_ty = CAShapeLayer()
    
    /// lineWidth: 仅适用于非直线进度条
    public init(type: TYProgressType_ty, size: CGSize, lineWidth: CGFloat = AdaptSize_ty(10)) {
        self.type_ty      = type
        self.lineWidth_ty = lineWidth
        super.init(frame: CGRect(origin: .zero, size: size))
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
            case .line:
                self.drawLineShape_ty()
            case .round:
                self.drawRoundShape_ty()
        }
    }
    
    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.backgroundColor = .clear
    }
    
    // MARK: ==== Event ====
    private func drawLineShape_ty() {
        let bottomLayer             = CAShapeLayer()
        bottomLayer.frame           = bounds
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        bottomLayer.cornerRadius    = height_ty/2
        self.layer.addSublayer(bottomLayer)
        
        progressLayer_ty.frame           = CGRect(x: 0, y: 0, width: 0, height: height_ty)
        progressLayer_ty.backgroundColor = UIColor.blue.cgColor
        progressLayer_ty.cornerRadius    = height_ty/2
        
        self.layer.addSublayer(progressLayer_ty)
    }
    
    private func drawRoundShape_ty() {
        let center     = CGPoint(x: width_ty/2, y: height_ty/2)
        let radius     = (width_ty - lineWidth_ty*2)/2
        let startAngle = -CGFloat.pi/2
        let endAngle   = CGFloat.pi*3/2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let bottomLayer         = CAShapeLayer()
        bottomLayer.path        = path.cgPath
        bottomLayer.frame       = bounds
        bottomLayer.fillColor   = UIColor.clear.cgColor
        bottomLayer.strokeColor = UIColor.clear.cgColor
        bottomLayer.lineWidth   = lineWidth_ty
        self.layer.addSublayer(bottomLayer)
        
        progressLayer_ty.path        = path.cgPath
        progressLayer_ty.lineWidth   = lineWidth_ty
        progressLayer_ty.lineCap     = .round
        progressLayer_ty.fillColor   = UIColor.clear.cgColor
        progressLayer_ty.strokeColor = UIColor.blue.cgColor
        progressLayer_ty.strokeEnd   = 0
        self.layer.addSublayer(progressLayer_ty)
    }
    
    public func updateProgress_ty(progress: CGFloat, duration: TimeInterval = 0.25, complete block: DefaultBlock_ty? = nil) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            switch self.type_ty {
                case .line:
                    self.progressLayer_ty.width_ty = self.width_ty * progress
                case .round:
                    self.progressLayer_ty.strokeEnd = progress
            }
        } completion: { finished in
            if finished {
                block?()
            }
        }
    }
}
