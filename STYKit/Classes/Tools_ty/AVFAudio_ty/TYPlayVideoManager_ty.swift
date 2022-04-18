//
//  TYPlayVideoManager.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//


import UIKit
import AVFoundation

public protocol TYVideoManagerDelegate_ty: NSObjectProtocol {
    /// 开始播放
    func playBlock_ty()
    /// 暂停播放
    func pauseBlock_ty()
    /// 播放进度
    func progressBlock_ty(progress: Double, currentSecond: Double)
    /// 状态更新
    func updateStatus_ty(status: AVPlayerItem.Status)
}

/// 播放视频
public class TYVideoManager_ty: NSObject {
    
    private var player_ty: AVPlayer?
    private var model_ty: TYMediaVideoModel_ty?
    private var contentLayer_ty: CALayer?
    weak var delegate_ty: TYVideoManagerDelegate_ty?
    
    public func setData_ty(model_ty: TYMediaVideoModel_ty, contentLayer_ty: CALayer) {
        self.model_ty        = model_ty
        self.contentLayer_ty = contentLayer_ty
        self.setPlayer_ty()
        self.addProgressObserver_ty()
    }

    /// 获取播放内容
    /// - Parameter url: 播放地址
    private func getAsset_ty() -> AVAsset? {
        guard let _model_ty = self.model_ty else { return nil }
        let url_ty: URL? = {
            if let path_ty = _model_ty.videoLocalPath_ty, FileManager.default.fileExists(atPath: path_ty) {
                return URL(fileURLWithPath: path_ty)
            } else if let path_ty = _model_ty.videoRemotePath_ty {
                return URL(string: path_ty)
            } else {
                return nil
            }
        }()
        guard let _url_ty = url_ty else { return nil }
        let asset_ty = AVAsset(url: _url_ty)
        return asset_ty
    }
    
    private func getItem_ty() -> AVPlayerItem? {
        guard let _asset_ty = self.getAsset_ty() else { return nil}
        let item_ty = AVPlayerItem(asset: _asset_ty)
        item_ty.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        return item_ty
    }
    
    private func setPlayer_ty() {
        guard let _item_ty = self.getItem_ty() else { return }
        self.player_ty  = AVPlayer(playerItem: _item_ty)
        let playLayer_ty   = AVPlayerLayer(player: self.player_ty!)
        playLayer_ty.frame = kWindow_ty.bounds
        self.contentLayer_ty?.addSublayer(playLayer_ty)
    }
    
    // MARK: ==== Event ====
    /// 播放
    public func play_ty() {
        guard self.player_ty?.currentItem?.asset.isPlayable ?? false else {
            kWindow_ty.toast_ty("资源不可播放")
            return
        }
        // 设置进度
        if let _item_ty = self.player_ty?.currentItem, _item_ty.currentTime() < _item_ty.duration {
            self.player_ty?.seek(to: _item_ty.currentTime())
        } else {
            self.player_ty?.seek(to: .zero)
        }
        self.player_ty?.play()
        DispatchQueue.main.async { [weak self] in
            self?.delegate_ty?.playBlock_ty()
        }
    }
    
    /// 暂停
    public func pause_ty() {
        self.player_ty?.pause()
        DispatchQueue.main.async { [weak self] in
            self?.delegate_ty?.pauseBlock_ty()
        }
    }
    
    /// 进度监听
    private func addProgressObserver_ty() {
        self.player_ty?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .global(), using: { [weak self] timer_ty in
            guard let self = self, let totalSecond_ty = self.player_ty?.currentItem?.duration.seconds, totalSecond_ty > 0 else {
                return
            }
            let progress_ty = timer_ty.seconds / totalSecond_ty
            if progress_ty >= 1 {
                self.pause_ty()
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.delegate_ty?.progressBlock_ty(progress: progress_ty, currentSecond: timer_ty.seconds)
            }
        })
    }
    
    // MARK: ==== KVO ====
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let status_ty = self.player_ty?.currentItem?.status else {
                    return
                }
                self.delegate_ty?.updateStatus_ty(status: status_ty)
            }
        }
    }
}
