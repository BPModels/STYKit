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
        
        set(newValue_ty) {
            var frame_ty = self.frame
            frame_ty.origin.y = newValue_ty
            self.frame = frame_ty
        }
    }

    /// 左边距离父控件的距离
    ///
    ///     self.frame.origin.x
    var left_ty: CGFloat {
        get{
            return self.frame.origin.x
        }
        
        set(newValue_ty){
            var frame_ty = self.frame
            frame_ty.origin.x = newValue_ty
            self.frame = frame_ty
        }
    }

    /// 当前View的底部,距离父控件顶部的距离
    ///
    ///     self.frame.maxY
    var bottom_ty: CGFloat {
        get {
            return self.frame.maxY
        }
        
        set(newValue_ty) {
            var frame_ty = self.frame
            frame_ty.origin.y = newValue_ty - self.frame.size.height
            self.frame = frame_ty
        }
    }

    /// 当前View的右边,距离父控件左边的距离
    ///
    ///     self.frame.maxX
    var right_ty: CGFloat {
        get {
            return self.frame.maxX
        }
        
        set(newValue_ty) {
            guard let superW_ty = superview?.width_ty else { return }
            var frame_ty = self.frame
            frame_ty.origin.x = superW_ty - newValue_ty - frame_ty.width
            self.frame = frame_ty
        }
    }

    /// 宽度
    var width_ty: CGFloat {
        get {
            return self.frame.size.width
        }

        set(newValue_ty) {
            var frame_ty = self.frame
            frame_ty.size.width = newValue_ty
            self.frame = frame_ty
        }
    }

    /// 高度
    var height_ty: CGFloat {
        get {
            return self.frame.size.height
        }

        set(newValue_ty) {
            var frame_ty = self.frame
            frame_ty.size.height = newValue_ty
            self.frame = frame_ty
        }
    }

    /// X轴的中心位置
    var centerX_ty: CGFloat {
        get {
            return self.center.x
        }

        set(newValue_ty) {
            self.center = CGPoint(x: newValue_ty, y: self.center.y)
        }
    }

    /// Y轴的中心位置
    var centerY_ty: CGFloat {
        get {
            return self.center.y
        }

        set(newValue_ty) {
            self.center = CGPoint(x: self.center.x, y: newValue_ty)
        }
    }

    /// 左上角的顶点,在父控件中的位置
    var origin_ty: CGPoint {
        get {
            return self.frame.origin
        }

        set(newValue_ty) {
            var frame_ty = self.frame
            frame_ty.origin = newValue_ty
            self.frame = frame_ty
        }
    }

    /// 尺寸大小
    var size_ty: CGSize {
        get {
            return self.frame.size
        }

        set(newValue_ty) {
            var frame_ty = self.frame
            frame_ty.size = newValue_ty
            self.frame = frame_ty
        }
    }
    
    // TODO: ==== Loading ====
    
    private struct AssociatedKeys_ty {
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
            if let animationView_ty = objc_getAssociatedObject(self, &AssociatedKeys_ty.loadingView_ty) as? UIActivityIndicatorView {
                return animationView_ty
            } else {
                let view_ty = UIActivityIndicatorView()
                view_ty.size_ty = CGSize(width: AdaptSize_ty(140), height: AdaptSize_ty(140))
                view_ty.hidesWhenStopped = true
                self.addSubview(view_ty)
                view_ty.snp.makeConstraints { make in
                    make.size.equalTo(view_ty.size_ty)
                    make.center.equalToSuperview()
                }
                self.loadingView_ty = view_ty
                return view_ty
            }
        }

        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.loadingView_ty, newValue_ty, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // TODO: ==== Tools ====
    
    /// 裁剪 view 的圆角,裁一角或者全裁
    ///
    /// 其实就是根据当前View的Size绘制了一个 CAShapeLayer,将其遮在了当前View的layer上,就是Mask层,使mask以外的区域不可见
    /// - parameter direction: 需要裁切的圆角方向,左上角(topLeft)、右上角(topRight)、左下角(bottomLeft)、右下角(bottomRight)或者所有角落(allCorners)
    /// - parameter cornerRadius: 圆角半径
    func clipRectCorner_ty(direction_ty: UIRectCorner, cornerRadius_ty: CGFloat) {
        let cornerSize_ty = CGSize(width:cornerRadius_ty, height:cornerRadius_ty)
        let maskPath_ty = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction_ty, cornerRadii: cornerSize_ty)
        let maskLayer_ty = CAShapeLayer()
        maskLayer_ty.frame = bounds
        maskLayer_ty.path  = maskPath_ty.cgPath
        layer.addSublayer(maskLayer_ty)
        layer.mask = maskLayer_ty
    }

    /// 根据需要,裁剪各个顶点为圆角
    ///
    /// 其实就是根据当前View的Size绘制了一个 CAShapeLayer,将其遮在了当前View的layer上,就是Mask层,使mask以外的区域不可见
    /// - parameter directionList: 需要裁切的圆角方向,左上角(topLeft)、右上角(topRight)、左下角(bottomLeft)、右下角(bottomRight)或者所有角落(allCorners)
    /// - parameter cornerRadius: 圆角半径
    /// - note: .pi等于180度,圆角计算,默认以圆横直径的右半部分顺时针开始计算(就类似上面那个圆形中的‘=====’线),当然如果参数 clockwies 设置false.则逆时针开始计算角度
    func clipRectCorner_ty(directionList_ty: [UIRectCorner], cornerRadius_ty radius_ty: CGFloat) {
        let bezierPath_ty = UIBezierPath()
        // 以左边中间节点开始绘制
        bezierPath_ty.move(to: CGPoint(x: 0, y: height_ty/2))
        // 如果左上角需要绘制圆角
        if directionList_ty.contains(.topLeft) {
            bezierPath_ty.move(to: CGPoint(x: 0, y: radius_ty))
            bezierPath_ty.addArc(withCenter: CGPoint(x: radius_ty, y: radius_ty), radius: radius_ty, startAngle: .pi, endAngle: .pi * 1.5, clockwise: true)
        } else {
            bezierPath_ty.addLine(to: origin_ty)
        }
        // 如果右上角需要绘制
        if directionList_ty.contains(.topRight) {
            bezierPath_ty.addLine(to: CGPoint(x: right_ty - radius_ty, y: 0))
            bezierPath_ty.addArc(withCenter: CGPoint(x: width_ty - radius_ty, y: radius_ty), radius: radius_ty, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 2, clockwise: true)
        } else {
            bezierPath_ty.addLine(to: CGPoint(x: width_ty, y: 0))
        }
        // 如果右下角需要绘制
        if directionList_ty.contains(.bottomRight) {
            bezierPath_ty.addLine(to: CGPoint(x: width_ty, y: height_ty - radius_ty))
            bezierPath_ty.addArc(withCenter: CGPoint(x: width_ty - radius_ty, y: height_ty - radius_ty), radius: radius_ty, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        } else {
            bezierPath_ty.addLine(to: CGPoint(x: width_ty, y: height_ty))
        }
        // 如果左下角需要绘制
        if directionList_ty.contains(.bottomLeft) {
            bezierPath_ty.addLine(to: CGPoint(x: radius_ty, y: height_ty))
            bezierPath_ty.addArc(withCenter: CGPoint(x: radius_ty, y: height_ty - radius_ty), radius: radius_ty, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        } else {
            bezierPath_ty.addLine(to: CGPoint(x: 0, y: height_ty))
        }
        // 与开始节点闭合
        bezierPath_ty.addLine(to: CGPoint(x: 0, y: height_ty/2))

        let maskLayer_ty   = CAShapeLayer()
        maskLayer_ty.frame = bounds
        maskLayer_ty.path  = bezierPath_ty.cgPath
        layer.mask         = maskLayer_ty
    }
    
    /// 隐藏高斯模糊
    func hideBlurEffect_ty() {
        if let effectView_ty = objc_getAssociatedObject(self, &AssociatedKeys_ty.blurEffect_ty) as? UIVisualEffectView {
            effectView_ty.isHidden = true
        }
    }
    
    /// 将当前视图转为UIImage
    func toImage_ty() -> UIImage {
        let renderer_ty = UIGraphicsImageRenderer(bounds: bounds)
        return renderer_ty.image { rendererContext_ty in
            layer.render(in: rendererContext_ty.cgContext)
        }
    }
    
    /// 显示弹框
    /// - Parameter message: 弹框内容
    func toast_ty(_ message_ty: String) {
        let toastView_ty = TYToastView_ty(message_ty)
        toastView_ty.show_ty()
    }
}
