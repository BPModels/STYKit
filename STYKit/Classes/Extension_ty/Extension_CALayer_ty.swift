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
