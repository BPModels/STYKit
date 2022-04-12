//
//  TYPlayVideoManager.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//


import UIKit
import AVFoundation

protocol TYVideoManagerDelegate: NSObjectProtocol {
    /// 开始播放
    func playBlock_ty()
    /// 暂停播放
    func pauseBlock_ty()
    /// 播放进度
    func progressBlock_ty(progress: Double, currentSecond: Double)
    /// 状态更新
    func updateStatus_ty(status: AVPlayerItem.Status)
}

class TYVideoManager: NSObject {
    
    private var player_ty: AVPlayer?
    private var model_ty: TYMediaVideoModel?
    private var contentLayer_ty: CALayer?
    weak var delegate_ty: TYVideoManagerDelegate?
    
    func setData_ty(model: TYMediaVideoModel, contentLayer: CALayer) {
        self.model_ty        = model
        self.contentLayer_ty = contentLayer
        self.setPlayer_ty()
        self.addProgressObserver_ty()
    }

    /// 获取播放内容
    /// - Parameter url: 播放地址
    private func getAsset_ty() -> AVAsset? {
        guard let _model = self.model_ty else { return nil }
        let url: URL? = {
            if let path = _model.videoLocalPath_ty, FileManager.default.fileExists(atPath: path) {
                return URL(fileURLWithPath: path)
            } else if let path = _model.videoRemotePath_ty {
                return URL(string: path)
            } else {
                return nil
            }
        }()
        guard let _url = url else { return nil }
        let asset = AVAsset(url: _url)
        return asset
    }
    
    private func getItem_ty() -> AVPlayerItem? {
        guard let _asset = self.getAsset_ty() else { return nil}
        let item = AVPlayerItem(asset: _asset)
        item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        return item
    }
    
    private func setPlayer_ty() {
        guard let _item = self.getItem_ty() else { return }
        self.player_ty  = AVPlayer(playerItem: _item)
        let playLayer   = AVPlayerLayer(player: self.player_ty!)
        playLayer.frame = kWindow_ty.bounds
        self.contentLayer_ty?.addSublayer(playLayer)
    }
    
    // MARK: ==== Event ====
    /// 播放
    func play_ty() {
        guard self.player_ty?.currentItem?.asset.isPlayable ?? false else {
            kWindow_ty.toast_ty("资源不可播放")
            return
        }
        // 设置进度
        if let _item = self.player_ty?.currentItem, _item.currentTime() < _item.duration {
            self.player_ty?.seek(to: _item.currentTime())
        } else {
            self.player_ty?.seek(to: .zero)
        }
        self.player_ty?.play()
        DispatchQueue.main.async { [weak self] in
            self?.delegate_ty?.playBlock_ty()
        }
    }
    
    /// 暂停
    func pause_ty() {
        self.player_ty?.pause()
        DispatchQueue.main.async { [weak self] in
            self?.delegate_ty?.pauseBlock_ty()
        }
    }
    
    /// 进度监听
    private func addProgressObserver_ty() {
        self.player_ty?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .global(), using: { [weak self] timer in
            guard let self = self, let totalSecond = self.player_ty?.currentItem?.duration.seconds, totalSecond > 0 else {
                return
            }
            let progress = timer.seconds / totalSecond
            if progress >= 1 {
                self.pause_ty()
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.delegate_ty?.progressBlock_ty(progress: progress, currentSecond: timer.seconds)
            }
        })
    }
    
    // MARK: ==== KVO ====
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let status = self.player_ty?.currentItem?.status else {
                    return
                }
                self.delegate_ty?.updateStatus_ty(status: status)
            }
        }
    }
}
