//
//  TYBrowserImageCell_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import UIKit
import Photos

protocol TYBrowserImageCellDelegate_ty: NSObjectProtocol {
    func clickAction_ty(view_ty: UIView)
    func longPressAction_ty(image_ty: UIImage?)
    func scrolling_ty(reduce_ty scale_ty: Float)
    func closeAction_ty(view_ty: UIView)
}

class TYBrowserImageCell_ty: TYCollectionViewCell_ty, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    /// 手指离开后，超过该值则关闭视图
    private let maxOffsetY_ty: CGFloat     = 100
    /// 最大滑动缩放范围
    private let maxScaleY_ty: CGFloat      = AdaptSize_ty(1000)
    /// 拖动最小缩放比例
    private let drawMinScale_ty: CGFloat   = 0.5
    /// 放大最大比例
    private let zoomUpMaxScal_ty: CGFloat  = 10
    /// 放大最小比例
    private let zoomUpMinScal_ty: CGFloat  = 2
    
    weak var delegate_ty: TYBrowserImageCellDelegate_ty?
    private var panGes_ty: UIPanGestureRecognizer?
    /// 页面是否在滑动中
    private var isScrolling_ty     = false
    /// 当前放大比例
    private var scale_ty: CGFloat  = 1 {
        willSet(newValue_ty) {
            print("被修改了：\(newValue_ty)")
        }
    }

    private var scrollView_ty: UIScrollView = {
        let scrollView_ty = UIScrollView()
        scrollView_ty.zoomScale        = 1
        scrollView_ty.maximumZoomScale = 3
        scrollView_ty.minimumZoomScale = 1
        scrollView_ty.showsHorizontalScrollIndicator = false
        scrollView_ty.showsVerticalScrollIndicator   = false
        return scrollView_ty
    }()
    private var imageView_ty: UIImageView = {
        let imageView_ty = UIImageView()
        imageView_ty.contentMode = .scaleAspectFit
        imageView_ty.isUserInteractionEnabled = true
        return imageView_ty
    }()
    private var progressView_ty = TYProgressView_ty(type_ty: .round_ty, size_ty: CGSize(width: AdaptSize_ty(60), height: AdaptSize_ty(60)), lineWidth_ty: AdaptSize_ty(5))

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func createSubviews_ty() {
        super.createSubviews_ty()
        self.addSubview(scrollView_ty)
        scrollView_ty.addSubview(imageView_ty)
        scrollView_ty.addSubview(progressView_ty)
        scrollView_ty.frame = CGRect(origin: .zero, size: kWindow_ty.size_ty)
        imageView_ty.frame  = CGRect(origin: .zero, size: kWindow_ty.size_ty)
        scrollView_ty.contentSize = kWindow_ty.size_ty
        progressView_ty.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(progressView_ty.size_ty)
        }
    }

    internal override func bindProperty_ty() {
        super.bindProperty_ty()
        self.scrollView_ty.delegate     = self
        self.backgroundColor            = .clear
        self.progressView_ty.isHidden   = true
        self.configGesture()
    }
    
    /// 配置手势
    private func configGesture() {
        let tapGes_ty       = UITapGestureRecognizer(target: self, action: #selector(tapAction_ty(sender_ty:)))
        tapGes_ty.numberOfTapsRequired    = 1
        tapGes_ty.numberOfTouchesRequired = 1
        let doubleTapGes_ty = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction_ty(sender_ty:)))
        doubleTapGes_ty.numberOfTapsRequired    = 2
        doubleTapGes_ty.numberOfTouchesRequired = 1
        let longPressGes_ty = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction_ty(sender_ty:)))
        self.panGes_ty = UIPanGestureRecognizer(target: self, action: #selector(self.panAction_ty(sender_ty:)))
        self.panGes_ty?.maximumNumberOfTouches = 1
        self.imageView_ty.addGestureRecognizer(tapGes_ty)
        self.imageView_ty.addGestureRecognizer(doubleTapGes_ty)
        self.addGestureRecognizer(longPressGes_ty)
        self.imageView_ty.addGestureRecognizer(panGes_ty!)
        panGes_ty?.delegate = self
        tapGes_ty.require(toFail: doubleTapGes_ty)
    }

    // MARK: ==== Event ====

    func setCustomData_ty(model_ty: TYMediaImageModel_ty, userId_ty: String) {
        self.getOriginImage_ty(model_ty: model_ty, progress_ty: nil, completion_ty: { [weak self] (image_ty: UIImage?) in
            guard let self = self else { return }
            self.imageView_ty.image = image_ty
            self.updateZoomScale_ty()
        }, userId_ty: userId_ty)
    }
    
    func setSystemData_ty(asset_ty: PHAsset) {
        asset_ty.toMediaImageModel_ty { [weak self] progress_ty in
            guard let self = self, let _progress_ty = progress_ty else { return }
            self.progressView_ty.isHidden = false
            self.progressView_ty.updateProgress_ty(progress_ty: CGFloat(_progress_ty))
            self.progressView_ty.isHidden = _progress_ty >= 1
        } completeBlock_ty: { model_ty in
            self.imageView_ty.image = model_ty.image_ty
            self.updateZoomScale_ty()
        }
    }
    
    private func resetScale_ty() {
        self.imageView_ty.frame        = self.bounds
        self.scrollView_ty.contentSize = self.bounds.size
    }

    @objc private func didEndScroll_ty() {
//        self.resetScale()
    }

    /// 点击手势事件
    @objc private func tapAction_ty(sender_ty: UITapGestureRecognizer) {
        self.delegate_ty?.clickAction_ty(view_ty: self.imageView_ty)
    }
    
    /// 双击手势事件
    @objc private func doubleTapAction_ty(sender_ty: UITapGestureRecognizer) {
        var _point_ty: CGPoint = sender_ty.location(in: self.imageView_ty)
        let _scale_ty: CGFloat = self.scale_ty >= 2 ? 1 : 2
        var _rect_ty = self.bounds
        if _scale_ty == 2 {
            _point_ty = CGPoint(x: imageView_ty.width_ty - _point_ty.x, y: imageView_ty.height_ty - _point_ty.y)
            _rect_ty  = self.getZoomRect_ty(scale_ty: _scale_ty, center_ty: _point_ty)
        }
        self.scrollView_ty.contentSize  = _rect_ty.size
        self.scrollView_ty.contentInset = UIEdgeInsets(top: abs(_rect_ty.origin.y), left: abs(_rect_ty.origin.x), bottom: _rect_ty.origin.y, right: _rect_ty.origin.x)
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.imageView_ty.frame        = _rect_ty
        } completion: { [weak self] finished_ty in
            guard let self = self else { return }
            self.scale_ty = _scale_ty
        }
    }
    
    private func getZoomRect_ty(scale_ty: CGFloat, center_ty: CGPoint) -> CGRect {
        let _height_ty = self.height_ty * scale_ty
        let _width_ty  = self.width_ty * scale_ty
        let _x_ty      = center.x - _width_ty/2
        let _y_ty      = center.y - _height_ty/2
        return CGRect(x: _x_ty, y: _y_ty, width: _width_ty, height: _height_ty)
    }

    /// 长按手势事件
    @objc private func longPressAction_ty(sender_ty: UILongPressGestureRecognizer) {
        if sender_ty.state == .began {
            self.delegate_ty?.longPressAction_ty(image_ty: self.imageView_ty.image)
        }
    }
    
    private var originPoint_ty = CGPoint.zero
    /// 滑动手势
    @objc private func panAction_ty(sender_ty: UIPanGestureRecognizer) {
        if self.scale_ty > 1 {
            guard sender_ty.state == .ended else { return }
            print(self.imageView_ty.frame)
//            if self.scrollView.contentOffset.y < AdaptSize(-200) {
//                self.delegate?.closeAction(imageView: self.imageView)
//            }
        } else {
            let point_ty = sender_ty.translation(in: self)
            switch sender_ty.state {
            case .began:
                self.originPoint_ty = point_ty
            case .changed:
                guard point_ty.y > 10, !isScrolling_ty else {
                    return
                }
                let scale_ty: CGFloat = {
                    if point_ty.y > self.maxScaleY_ty {
                        return self.drawMinScale_ty
                    } else {
                        let _scale_ty = (self.maxScaleY_ty - point_ty.y) / self.maxScaleY_ty
                        return _scale_ty > self.drawMinScale_ty ? _scale_ty : self.drawMinScale_ty
                    }
                }()
                self.delegate_ty?.scrolling_ty(reduce_ty: Float(scale_ty))
                // a:控制x轴缩放；d：控制y轴缩放；
                self.imageView_ty.transform = CGAffineTransform(a: scale_ty, b: 0, c: 0, d: scale_ty, tx: point_ty.x, ty: point_ty.y)
            case .ended:
                if point_ty.y - originPoint_ty.y > self.maxOffsetY_ty {
                    self.delegate_ty?.closeAction_ty(view_ty: self.imageView_ty)
                } else {
                    UIView.animate(withDuration: 0.15) { [weak self] in
                        self?.imageView_ty.transform = .identity
                    }
                }
            default:
                return
            }
        }
    }
    /// 更新图片放大比例
    func updateZoomScale_ty() {
        guard let _image_ty = self.imageView_ty.image else { return }
        let imageSize_ty   = _image_ty.size.width * _image_ty.size.height
        let currentSize_ty = self.width_ty * height_ty
        var scale_ty = imageSize_ty / currentSize_ty
        guard scale_ty > 1 else { return }
        scale_ty = scale_ty < zoomUpMinScal_ty ? zoomUpMinScal_ty : scale_ty
        scale_ty = scale_ty > zoomUpMaxScal_ty ? zoomUpMaxScal_ty : scale_ty
        self.scrollView_ty.maximumZoomScale = scale_ty
    }
    
    /// 显示原图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    private func getOriginImage_ty(model_ty: TYMediaImageModel_ty, progress_ty: ((CGFloat) ->Void)?, completion_ty: ((UIImage?)->Void)?, userId_ty: String) {
        if let image_ty = model_ty.image_ty {
            completion_ty?(image_ty)
            return
        }
        if let _sessionId_ty = model_ty.sessionId_ty, _sessionId_ty.isNotEmpty_ty,
           let imageData_ty = TYFileManager_ty.share_ty.getSessionMedia_ty(type_ty: .sessionImage_ty, name_ty: model_ty.originLocalPath_ty!, sessionId_ty: _sessionId_ty, userId_ty: userId_ty){
            // 如果是聊天室查看
            completion_ty?(UIImage(data: imageData_ty))
        } else {
            if let _path_ty = model_ty.originLocalPath_ty, let image_ty = UIImage(contentsOfFile: _path_ty) {
                completion_ty?(image_ty)
            } else if let path_ty = model_ty.originRemotePath_ty {
                TYDownloadManager_ty.share_ty.image_ty(urlStr_ty: path_ty, progress_ty: progress_ty, completion_ty: completion_ty)
            } else {
                completion_ty?(nil)
            }
        }
    }
    
    // MARK: ==== UIScrollViewDelegate ====
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView_ty
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var frame_ty = self.imageView_ty.frame
        frame_ty.origin.y = scrollView.height_ty - imageView_ty.height_ty > 0 ? (scrollView.height_ty - imageView_ty.height_ty)/2 : 0
        frame_ty.origin.x  = scrollView.width_ty - imageView_ty.width_ty > 0 ? (scrollView.width_ty - imageView_ty.width_ty)/2 : 0
        self.imageView_ty.frame         = frame_ty
        self.scrollView_ty.contentSize  = frame_ty.size
        self.scrollView_ty.contentInset = .zero
        self.scale_ty = frame_ty.width / self.width_ty
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // 防止过多缩小
        if self.scale_ty < 1 {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self = self else { return }
                self.imageView_ty.frame        = self.bounds
                self.scrollView_ty.contentSize = self.size_ty
            } completion: { [weak self] finished in
                guard let self = self else { return }
                self.scale_ty = 1
            }
        }
    }
    
    // MARK: ==== UIGestureRecognizerDelegat ====
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

