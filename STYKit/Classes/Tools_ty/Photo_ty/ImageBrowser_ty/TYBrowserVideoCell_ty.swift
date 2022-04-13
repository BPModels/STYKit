//
//  TYBrowserVideoCell_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import UIKit
import AVFoundation

protocol TYBrowserVideoCellDelegate_ty: NSObjectProtocol {
    func videoViewLongPressAction_ty(model: TYMediaVideoModel_ty?)
    func videoViewClosedAction_ty(view: UIView)
    func scrolling_ty(reduce scale: Float)
    func closeAction_ty(view: UIView)
}

class TYBrowserVideoCell_ty:
    TYCollectionViewCell_ty,
    TYVideoManagerDelegate_ty,
    UIGestureRecognizerDelegate {
    
    weak var delegate_ty: TYBrowserVideoCellDelegate_ty?
    private let playManager_ty = TYVideoManager_ty()
    private var model_ty: TYMediaVideoModel_ty?
    // TODO: ---- 手势相关 ----
    private var originPoint_ty = CGPoint.zero
    /// 手指离开后，超过该值则关闭视图
    private let maxOffsetY_ty: CGFloat     = 100
    /// 页面是否在滑动中
    private var isScrolling_ty     = false
    /// 最大滑动缩放范围
    private let maxScaleY_ty: CGFloat      = AdaptSize_ty(1000)
    /// 拖动最小缩放比例
    private let drawMinScale_ty: CGFloat   = 0.5
    
    private var customContentView_ty = TYView_ty()
    
    private var playButton_ty: TYButton_ty = {
        let button = TYButton_ty()
        button.setTitle("播放", for: .normal)
        button.setTitle("暂停", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.regular_ty(size: AdaptSize_ty(14))
        button.isHidden = true
        return button
    }()
    
    private var leftTimeLabel_ty: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = "00:00"
        label.textColor     = UIColor.white
        label.font          = UIFont.regular_ty(size: AdaptSize_ty(12))
        label.textAlignment = .left
        return label
    }()
    
    private var rightTimeLabel_ty: TYLabel_ty = {
        let label = TYLabel_ty()
        label.text          = "00:00"
        label.textColor     = UIColor.white
        label.font          = UIFont.regular_ty(size: AdaptSize_ty(12))
        label.textAlignment = .left
        return label
    }()
    
    private var progressView_ty = TYProgressView_ty(type: .line, size: CGSize(width: AdaptSize_ty(250), height: AdaptSize_ty(2)))
    
    private var closedButton_ty: TYButton_ty = {
        let button = TYButton_ty()
        button.setTitle("关闭", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font    = UIFont.regular_ty(size: AdaptSize_ty(10))
        button.backgroundColor     = UIColor.gray0_ty.withAlphaComponent(0.4)
        button.layer.cornerRadius  = AdaptSize_ty(15)
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews_ty()
        self.bindProperty_ty()
        self.updateUI_ty()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func createSubviews_ty() {
        self.contentView.addSubview(customContentView_ty)
        self.customContentView_ty.addSubview(playButton_ty)
        self.customContentView_ty.addSubview(leftTimeLabel_ty)
        self.customContentView_ty.addSubview(progressView_ty)
        self.customContentView_ty.addSubview(rightTimeLabel_ty)
        self.customContentView_ty.addSubview(closedButton_ty)
        
        customContentView_ty.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        closedButton_ty.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize_ty(15))
            make.bottom.equalToSuperview().offset(AdaptSize_ty(-15) - kSafeBottomMargin_ty)
            make.size.equalTo(CGSize(width: AdaptSize_ty(30), height: AdaptSize_ty(30)))
        }
        playButton_ty.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: AdaptSize_ty(40), height: AdaptSize_ty(40)))
            make.left.equalToSuperview()
            make.bottom.equalTo(closedButton_ty.snp.top).offset(AdaptSize_ty(-20))
        }
        leftTimeLabel_ty.sizeToFit()
        leftTimeLabel_ty.snp.makeConstraints { make in
            make.left.equalTo(playButton_ty.snp.right)
            make.centerY.equalTo(playButton_ty)
            make.width.equalTo(leftTimeLabel_ty.width_ty)
            make.height.equalTo(leftTimeLabel_ty.font.lineHeight)
        }
        progressView_ty.snp.makeConstraints { make in
            make.left.equalTo(leftTimeLabel_ty.snp.right).offset(AdaptSize_ty(5))
            make.centerY.equalTo(playButton_ty)
            make.size.equalTo(progressView_ty.size_ty)
        }
        rightTimeLabel_ty.sizeToFit()
        rightTimeLabel_ty.snp.makeConstraints { make in
            make.left.equalTo(progressView_ty.snp.right).offset(AdaptSize_ty(5))
            make.centerY.equalTo(playButton_ty)
            make.height.equalTo(rightTimeLabel_ty.font.lineHeight)
            make.width.equalTo(rightTimeLabel_ty.width_ty)
        }
    }
    
    internal override func bindProperty_ty() {
        self.closedButton_ty.addTarget(self, action: #selector(closedAction_ty), for: .touchUpInside)
        self.playButton_ty.addTarget(self, action: #selector(playAction_ty(sender:)), for: .touchUpInside)
        self.playManager_ty.delegate_ty = self
        self.configGesture_ty()
    }
    
    override func updateUI_ty() {
        super.updateUI_ty()
        self.backgroundColor                      = UIColor.clear
        self.contentView.backgroundColor          = UIColor.clear
        self.customContentView_ty.backgroundColor = UIColor.clear
    }
    
    /// 配置手势
    private func configGesture_ty() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGesAction))
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(sender:)))
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(panGesAction(sender:)))
        panGes.maximumNumberOfTouches = 1
        panGes.delegate = self
        self.addGestureRecognizer(tapGes)
        self.addGestureRecognizer(longPressGes)
        self.customContentView_ty.addGestureRecognizer(panGes)
    }
    
    // MARK: ==== Event ====
    func setData_ty(model: TYMediaVideoModel_ty) {
        self.model_ty = model
        self.playManager_ty.setData_ty(model: model, contentLayer: self.customContentView_ty.layer)
    }
    
    @objc private func playAction_ty(sender: TYButton_ty) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.playAction_ty()
        } else {
            self.pauseAction_ty()
        }
    }
    
    @objc private func closedAction_ty() {
        self.delegate_ty?.videoViewClosedAction_ty(view: self.contentView)
    }
    
    @objc private func playAction_ty() {
        self.playManager_ty.play_ty()
    }
    
    @objc private func pauseAction_ty() {
        self.playManager_ty.pause_ty()
    }
    
    @objc private func tapGesAction() {
        self.playButton_ty.isHidden     = !self.playButton_ty.isHidden
        self.leftTimeLabel_ty.isHidden  = !self.leftTimeLabel_ty.isHidden
        self.progressView_ty.isHidden   = !self.progressView_ty.isHidden
        self.rightTimeLabel_ty.isHidden = !self.rightTimeLabel_ty.isHidden
        self.closedButton_ty.isHidden   = !self.closedButton_ty.isHidden
    }
    
    @objc private func longPressAction(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.delegate_ty?.videoViewLongPressAction_ty(model: self.model_ty)
        }
    }
    
    @objc private func panGesAction(sender: UIPanGestureRecognizer) {
        
        let point = sender.translation(in: self.customContentView_ty)
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
            self.customContentView_ty.transform = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: point.x, ty: point.y)
        case .ended:
            if point.y - originPoint_ty.y > self.maxOffsetY_ty {
                self.delegate_ty?.closeAction_ty(view: self.customContentView_ty)
            } else {
                UIView.animate(withDuration: 0.15) { [weak self] in
                    self?.customContentView_ty.transform = .identity
                }
            }
        default:
            return
        }
    }
    
    // MARK: ==== TYVideoManagerDelegate_ty ====
    /// 开始播放
    func playBlock_ty() {
        self.playButton_ty.isSelected = true
    }
    /// 暂停播放
    func pauseBlock_ty() {
        self.playButton_ty.isSelected = false
    }
    /// 播放进度
    func progressBlock_ty(progress: Double, currentSecond: Double) {
        self.progressView_ty.updateProgress_ty(progress: CGFloat(progress))
        self.leftTimeLabel_ty.text = currentSecond.minuteSecondStr_ty()
    }
    func updateStatus_ty(status: AVPlayerItem.Status) {
        if status == .readyToPlay {
            self.playButton_ty.isHidden = false
        }
    }
    
    // MARK: ==== UIGestureRecognizerDelegate ====
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

