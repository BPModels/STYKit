//
//  TYBrowserImageCell.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import UIKit
import Photos

protocol TYBrowserImageCellDelegate: NSObjectProtocol {
    func clickAction_ty(view: UIView)
    func longPressAction_ty(image: UIImage?)
    func scrolling_ty(reduce scale: Float)
    func closeAction_ty(view: UIView)
}

class TYBrowserImageCell: TYCollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate {

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
    
    weak var delegate_ty: TYBrowserImageCellDelegate?
    private var panGes_ty: UIPanGestureRecognizer?
    /// 页面是否在滑动中
    private var isScrolling_ty     = false
    /// 当前放大比例
    private var scale_ty: CGFloat  = 1 {
        willSet {
            print("被修改了：\(newValue)")
        }
    }

    private var scrollView_ty: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.zoomScale        = 1
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 1
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator   = false
        return scrollView
    }()
    private var imageView_ty: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private var progressView_ty = TYProgressView(type: .round, size: CGSize(width: AdaptSize_ty(60), height: AdaptSize_ty(60)), lineWidth: AdaptSize_ty(5))

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
        self.scrollView_ty.delegate = self
        self.backgroundColor     = .clear
        self.progressView_ty.isHidden = true
        self.configGesture()
    }
    
    /// 配置手势
    private func configGesture() {
        let tapGes       = UITapGestureRecognizer(target: self, action: #selector(tapAction_ty(sender:)))
        tapGes.numberOfTapsRequired    = 1
        tapGes.numberOfTouchesRequired = 1
        let doubleTapGes = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction_ty(sender:)))
        doubleTapGes.numberOfTapsRequired    = 2
        doubleTapGes.numberOfTouchesRequired = 1
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction_ty(sender:)))
        self.panGes_ty = UIPanGestureRecognizer(target: self, action: #selector(self.panAction_ty(sender:)))
        self.panGes_ty?.maximumNumberOfTouches = 1
        self.imageView_ty.addGestureRecognizer(tapGes)
        self.imageView_ty.addGestureRecognizer(doubleTapGes)
        self.addGestureRecognizer(longPressGes)
        self.imageView_ty.addGestureRecognizer(panGes_ty!)
        panGes_ty?.delegate = self
        tapGes.require(toFail: doubleTapGes)
    }

    // MARK: ==== Event ====

    func setCustomData_ty(model: TYMediaImageModel, userId: String) {
        self.getOriginImage_ty(model: model, progress: nil, completion: { [weak self] (image: UIImage?) in
            guard let self = self else { return }
            self.imageView_ty.image = image
            self.updateZoomScale_ty()
        }, userId: userId)
    }
    
    func setSystemData_ty(asset: PHAsset) {
        asset.toMediaImageModel_ty { [weak self] progress in
            guard let self = self, let _progress = progress else { return }
            self.progressView_ty.isHidden = false
            self.progressView_ty.updateProgress_ty(progress: CGFloat(_progress))
            self.progressView_ty.isHidden = _progress >= 1
        } completeBlock: { model in
            self.imageView_ty.image = model.image_ty
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
    @objc private func tapAction_ty(sender: UITapGestureRecognizer) {
        self.delegate_ty?.clickAction_ty(view: self.imageView_ty)
    }
    
    /// 双击手势事件
    @objc private func doubleTapAction_ty(sender: UITapGestureRecognizer) {
        var _point: CGPoint = sender.location(in: self.imageView_ty)
        let _scale: CGFloat = self.scale_ty >= 2 ? 1 : 2
        var _rect = self.bounds
        if _scale == 2 {
            _point = CGPoint(x: imageView_ty.width_ty - _point.x, y: imageView_ty.height_ty - _point.y)
            _rect  = self.getZoomRect_ty(scale: _scale, center: _point)
        }
        self.scrollView_ty.contentSize  = _rect.size
        self.scrollView_ty.contentInset = UIEdgeInsets(top: abs(_rect.origin.y), left: abs(_rect.origin.x), bottom: _rect.origin.y, right: _rect.origin.x)
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.imageView_ty.frame        = _rect
        } completion: { [weak self] finished in
            guard let self = self else { return }
            self.scale_ty = _scale
        }
    }
    
    private func getZoomRect_ty(scale: CGFloat, center: CGPoint) -> CGRect {
        let _height = self.height_ty * scale
        let _width  = self.width_ty * scale
        let _x      = center.x - _width/2
        let _y      = center.y - _height/2
        return CGRect(x: _x, y: _y, width: _width, height: _height)
    }

    /// 长按手势事件
    @objc private func longPressAction_ty(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.delegate_ty?.longPressAction_ty(image: self.imageView_ty.image)
        }
    }
    
    private var originPoint_ty = CGPoint.zero
    /// 滑动手势
    @objc private func panAction_ty(sender: UIPanGestureRecognizer) {
        if self.scale_ty > 1 {
            guard sender.state == .ended else { return }
            print(self.imageView_ty.frame)
//            if self.scrollView.contentOffset.y < AdaptSize(-200) {
//                self.delegate?.closeAction(imageView: self.imageView)
//            }
        } else {
            let point = sender.translation(in: self)
            switch sender.state {
            case .began:
                self.originPoint_ty = point
            case .changed:
                guard point.y > 10, !isScrolling_ty else {
                    return
                }
                let scale: CGFloat = {
                    if point.y > self.maxScaleY_ty {
                        return self.drawMinScale_ty
                    } else {
                        let _scale = (self.maxScaleY_ty - point.y) / self.maxScaleY_ty
                        return _scale > self.drawMinScale_ty ? _scale : self.drawMinScale_ty
                    }
                }()
                self.delegate_ty?.scrolling_ty(reduce: Float(scale))
                // a:控制x轴缩放；d：控制y轴缩放；
                self.imageView_ty.transform = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: point.x, ty: point.y)
            case .ended:
                if point.y - originPoint_ty.y > self.maxOffsetY_ty {
                    self.delegate_ty?.closeAction_ty(view: self.imageView_ty)
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
        guard let _image = self.imageView_ty.image else { return }
        let imageSize   = _image.size.width * _image.size.height
        let currentSize = self.width_ty * height_ty
        var scale = imageSize / currentSize
        guard scale > 1 else { return }
        scale = scale < zoomUpMinScal_ty ? zoomUpMinScal_ty : scale
        scale = scale > zoomUpMaxScal_ty ? zoomUpMaxScal_ty : scale
        self.scrollView_ty.maximumZoomScale = scale
    }
    
    /// 显示原图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    private func getOriginImage_ty(model: TYMediaImageModel, progress: ((CGFloat) ->Void)?, completion: ((UIImage?)->Void)?, userId: String) {
        if let image = model.image_ty {
            completion?(image)
            return
        }
        if let _sessionId = model.sessionId_ty, _sessionId.isNotEmpty_ty,
           let imageData = TYFileManager.share_ty.getSessionMedia_ty(type: .sessionImage, name: model.originLocalPath_ty!, sessionId: _sessionId, userId: userId){
            // 如果是聊天室查看
            completion?(UIImage(data: imageData))
        } else {
            if let _path = model.originLocalPath_ty, let image = UIImage(contentsOfFile: _path) {
                completion?(image)
            } else if let path = model.originRemotePath_ty {
                TYDownloadManager.share_ty.image_ty(urlStr: path, progress: progress, completion: completion)
            } else {
                completion?(nil)
            }
        }
    }
    
    // MARK: ==== UIScrollViewDelegate ====
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView_ty
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var frame = self.imageView_ty.frame
        frame.origin.y = scrollView.height_ty - imageView_ty.height_ty > 0 ? (scrollView.height_ty - imageView_ty.height_ty)/2 : 0
        frame.origin.x  = scrollView.width_ty - imageView_ty.width_ty > 0 ? (scrollView.width_ty - imageView_ty.width_ty)/2 : 0
        self.imageView_ty.frame         = frame
        self.scrollView_ty.contentSize  = frame.size
        self.scrollView_ty.contentInset = .zero
        self.scale_ty = frame.width / self.width_ty
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

