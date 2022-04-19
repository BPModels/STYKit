//
//  Extension_CALayer.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension CALayer {
    
    /// 顶部距离父控件的距离
    ///
    ///     self.frame.origin.y
    var top_ty: CGFloat {
        get{
            return self.frame.origin.y
        }

        set{
            var frame_ty = self.frame
            frame_ty.origin.y = newValue
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

        set(newValue_ty) {
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
            var frame_ty = self.frame
            frame_ty.origin.x = newValue_ty + self.frame.size.width
            self.frame = frame
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
    
    /// 设置默认阴影效果
    func setDefaultShadow_ty(alpha_ty: CGFloat = 0.2) {
        self.shadowColor   = UIColor.black.withAlphaComponent(alpha_ty).cgColor
        self.shadowOffset  = CGSize(width: AdaptSize_ty(1), height: AdaptSize_ty(1))
        self.shadowOpacity = 0.8
        self.shadowPath    = nil
        self.shadowRadius  = self.cornerRadius
    }
    
    /// 添加弹框动画,frame的比例放大缩小效果,类似果冻(Jelly)晃动
    /// - parameter duration: 动画持续时间
    func addJellyAnimation_ty(duration_ty: Double = 0.25){
        let animater_ty            = CAKeyframeAnimation(keyPath: "transform.scale")
        animater_ty.values         = [0.5, 1.1, 1.0]// 先保持大小比例,再放大,最后恢复默认大小
        animater_ty.duration       = duration_ty
        animater_ty.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.add(animater_ty, forKey: "jellyAnimation_ty")
    }
}

/// 渐变色的方向枚举
public enum TYGradientDirectionType_ty: Int {
    /// 水平(左->右)
    case horizontal_ty = 0
    /// 垂直(上->下)
    case vertical_ty   = 1
    /// 斜角(左上->右下)
    case leftTop_ty    = 2
    /// 斜角(左下->右上)
    case leftBottom_ty = 3
}

// MARK: - 渐变色
public extension CALayer {
    /// 根据方向,设置渐变色
    /// - parameter colors: 渐变的颜色数组
    /// - parameter direction: 渐变方向的枚举对象
    /// - note: 设置前,一定要确定当前View的高宽!!!否则无法准确的绘制
    func setGradient_ty(colors_ty: [UIColor], direction_ty: TYGradientDirectionType_ty) {
        switch direction_ty {
        case .horizontal_ty:
            setGradient_ty(colors_ty: colors_ty, startPoint_ty: CGPoint(x: 0, y: 0.5), endPoint_ty: CGPoint(x: 1, y: 0.5))
        case .vertical_ty:
            setGradient_ty(colors_ty: colors_ty, startPoint_ty: CGPoint(x: 0.5, y: 0), endPoint_ty: CGPoint(x: 0.5, y: 1))
        case .leftTop_ty:
            setGradient_ty(colors_ty: colors_ty, startPoint_ty: CGPoint(x: 0, y: 0), endPoint_ty: CGPoint(x: 1, y: 1))
        case .leftBottom_ty:
            setGradient_ty(colors_ty: colors_ty, startPoint_ty: CGPoint(x: 0, y: 1), endPoint_ty: CGPoint(x: 1, y: 0))
        }
    }

    /// 设置渐变色
    /// - parameter colors: 渐变颜色数组
    /// - parameter locations: 逐个对应渐变色的数组,设置颜色的渐变占比,nil则默认平均分配
    /// - parameter startPoint: 开始渐变的坐标(控制渐变的方向),取值(0 ~ 1)
    /// - parameter endPoint: 结束渐变的坐标(控制渐变的方向),取值(0 ~ 1)
    @discardableResult
    func setGradient_ty(colors_ty: [UIColor], locations_ty: [NSNumber]? = nil, startPoint_ty: CGPoint, endPoint_ty: CGPoint) -> CAGradientLayer {
        /// 设置渐变色
        func _setGradient(_ layer_ty: CAGradientLayer) {
            // self.layoutIfNeeded()
            var colorArr_ty = [CGColor]()
            for color_ty in colors_ty {
                colorArr_ty.append(color_ty.cgColor)
            }

            /** 将UI操作的事务,先打包提交,防止出现视觉上的延迟展示,
             * 但如果在提交的线程中还有其他UI操作,则这些UI操作会被隐式的包在CATransaction事务中
             * 则当前显式创建的CATransaction则还是会等到这个UI操作的事务结束后,才会展示,毕竟嵌套了嘛
             * 如果一定要立马展示,可以结束之前的UI操作,强制展示:CATransaction.flush(),缺点就是会造成其他UI操作的异常
             */
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer_ty.frame = self.bounds
            CATransaction.commit()

            layer_ty.colors     = colorArr_ty
            layer_ty.locations  = locations_ty
            layer_ty.startPoint = startPoint_ty
            layer_ty.endPoint   = endPoint_ty
        }

        //查找是否有已经存在的渐变色Layer
        var kCAGradientLayerType_ty = CAGradientLayerType.axial
        if let gradientLayer_ty = objc_getAssociatedObject(self, &kCAGradientLayerType_ty) as? CAGradientLayer {
            // 清除渐变颜色
            gradientLayer_ty.removeFromSuperlayer()
        }
        let gradientLayer_ty = CAGradientLayer()
        self.insertSublayer(gradientLayer_ty , at: 0)
        _setGradient(gradientLayer_ty)
        // 添加渐变色属性到当前Layer
        objc_setAssociatedObject(self, &kCAGradientLayerType_ty, gradientLayer_ty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gradientLayer_ty
    }
}
