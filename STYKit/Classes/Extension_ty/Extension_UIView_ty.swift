//
//  Extension_UIView.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UIView {

    /// 顶部距离父控件的距离
    ///
    ///     self.frame.origin.y
    var top_ty: CGFloat {
        get{
            return self.frame.origin.y
        }
        
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    /// 左边距离父控件的距离
    ///
    ///     self.frame.origin.x
    var left_ty: CGFloat {
        get{
            return self.frame.origin.x
        }
        
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    /// 当前View的底部,距离父控件顶部的距离
    ///
    ///     self.frame.maxY
    var bottom_ty: CGFloat {
        get {
            return self.frame.maxY
        }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }

    /// 当前View的右边,距离父控件左边的距离
    ///
    ///     self.frame.maxX
    var right_ty: CGFloat {
        get {
            return self.frame.maxX
        }
        
        set {
            guard let superW = superview?.width_ty else { return }
            var frame = self.frame
            frame.origin.x = superW - newValue - frame.width
            self.frame = frame
        }
    }

    /// 宽度
    var width_ty: CGFloat {
        get {
            return self.frame.size.width
        }

        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    /// 高度
    var height_ty: CGFloat {
        get {
            return self.frame.size.height
        }

        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }

    /// X轴的中心位置
    var centerX_ty: CGFloat {
        get {
            return self.center.x
        }

        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }

    /// Y轴的中心位置
    var centerY_ty: CGFloat {
        get {
            return self.center.y
        }

        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }

    /// 左上角的顶点,在父控件中的位置
    var origin_ty: CGPoint {
        get {
            return self.frame.origin
        }

        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }

    /// 尺寸大小
    var size_ty: CGSize {
        get {
            return self.frame.size
        }

        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    // TODO: ==== Loading ====
    
    private struct AssociatedKeys {
        /// 加载视图
        static var loadingView_ty = "kLoadingView_ty"
        /// 高斯模糊
        static var blurEffect_ty  = "kBlurEffect_ty"
    }
    
    /// 显示loading图
    func showLoading_ty() {
        self.loadingView_ty.startAnimating()
        self.loadingView_ty.isHidden = false
    }

    /// 隐藏loading图
    func hideLoading_ty() {
        self.loadingView_ty.stopAnimating()
        self.loadingView_ty.isHidden = true
    }
    
    /// Loading 视图
    private var loadingView_ty: UIActivityIndicatorView {
        get {
            if let animationView = objc_getAssociatedObject(self, &AssociatedKeys.loadingView_ty) as? UIActivityIndicatorView {
                return animationView
            } else {
                let view = UIActivityIndicatorView()
                view.size_ty = CGSize(width: AdaptSize_ty(140), height: AdaptSize_ty(140))
                view.hidesWhenStopped = true
                self.addSubview(view)
                view.snp.makeConstraints { make in
                    make.size.equalTo(view.size_ty)
                    make.center.equalToSuperview()
                }
                self.loadingView_ty = view
                return view
            }
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingView_ty, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // TODO: ==== Tools ====
    
    /// 裁剪 view 的圆角,裁一角或者全裁
    ///
    /// 其实就是根据当前View的Size绘制了一个 CAShapeLayer,将其遮在了当前View的layer上,就是Mask层,使mask以外的区域不可见
    /// - parameter direction: 需要裁切的圆角方向,左上角(topLeft)、右上角(topRight)、左下角(bottomLeft)、右下角(bottomRight)或者所有角落(allCorners)
    /// - parameter cornerRadius: 圆角半径
    func clipRectCorner_ty(direction: UIRectCorner, cornerRadius: CGFloat) {
        let cornerSize = CGSize(width:cornerRadius, height:cornerRadius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.addSublayer(maskLayer)
        layer.mask = maskLayer
    }

    /// 根据需要,裁剪各个顶点为圆角
    ///
    /// 其实就是根据当前View的Size绘制了一个 CAShapeLayer,将其遮在了当前View的layer上,就是Mask层,使mask以外的区域不可见
    /// - parameter directionList: 需要裁切的圆角方向,左上角(topLeft)、右上角(topRight)、左下角(bottomLeft)、右下角(bottomRight)或者所有角落(allCorners)
    /// - parameter cornerRadius: 圆角半径
    /// - note: .pi等于180度,圆角计算,默认以圆横直径的右半部分顺时针开始计算(就类似上面那个圆形中的‘=====’线),当然如果参数 clockwies 设置false.则逆时针开始计算角度
    func clipRectCorner_ty(directionList: [UIRectCorner], cornerRadius radius: CGFloat) {
        let bezierPath = UIBezierPath()
        // 以左边中间节点开始绘制
        bezierPath.move(to: CGPoint(x: 0, y: height_ty/2))
        // 如果左上角需要绘制圆角
        if directionList.contains(.topLeft) {
            bezierPath.move(to: CGPoint(x: 0, y: radius))
            bezierPath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: .pi, endAngle: .pi * 1.5, clockwise: true)
        } else {
            bezierPath.addLine(to: origin_ty)
        }
        // 如果右上角需要绘制
        if directionList.contains(.topRight) {
            bezierPath.addLine(to: CGPoint(x: right_ty - radius, y: 0))
            bezierPath.addArc(withCenter: CGPoint(x: width_ty - radius, y: radius), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 2, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: width_ty, y: 0))
        }
        // 如果右下角需要绘制
        if directionList.contains(.bottomRight) {
            bezierPath.addLine(to: CGPoint(x: width_ty, y: height_ty - radius))
            bezierPath.addArc(withCenter: CGPoint(x: width_ty - radius, y: height_ty - radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: width_ty, y: height_ty))
        }
        // 如果左下角需要绘制
        if directionList.contains(.bottomLeft) {
            bezierPath.addLine(to: CGPoint(x: radius, y: height_ty))
            bezierPath.addArc(withCenter: CGPoint(x: radius, y: height_ty - radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: 0, y: height_ty))
        }
        // 与开始节点闭合
        bezierPath.addLine(to: CGPoint(x: 0, y: height_ty/2))

        let maskLayer   = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path  = bezierPath.cgPath
        layer.mask      = maskLayer
    }
    
    /// 隐藏高斯模糊
    func hideBlurEffect_ty() {
        if let effectView = objc_getAssociatedObject(self, &AssociatedKeys.blurEffect_ty) as? UIVisualEffectView {
            effectView.isHidden = true
        }
    }
    
    /// 将当前视图转为UIImage
    func toImage_ty() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    /// 显示弹框
    /// - Parameter message: 弹框内容
    func toast_ty(_ message: String) {
        let toastView = TYToastView_ty(message: message)
        toastView.show_ty()
    }
}
