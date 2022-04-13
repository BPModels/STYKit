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
            var frame = self.frame
            frame.origin.x = newValue + self.frame.size.width
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
    
    /// 设置默认阴影效果
    func setDefaultShadow_ty(alpha: CGFloat = 0.2) {
        self.shadowColor   = UIColor.black.withAlphaComponent(alpha).cgColor
        self.shadowOffset  = CGSize(width: AdaptSize_ty(1), height: AdaptSize_ty(1))
        self.shadowOpacity = 0.8
        self.shadowPath    = nil
        self.shadowRadius  = self.cornerRadius
    }
    
    /// 添加弹框动画,frame的比例放大缩小效果,类似果冻(Jelly)晃动
    /// - parameter duration: 动画持续时间
    func addJellyAnimation_ty(duration: Double = 0.25){
        let animater            = CAKeyframeAnimation(keyPath: "transform.scale")
        animater.values         = [0.5, 1.1, 1.0]// 先保持大小比例,再放大,最后恢复默认大小
        animater.duration       = duration
        animater.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.add(animater, forKey: "jellyAnimation")
    }

}
