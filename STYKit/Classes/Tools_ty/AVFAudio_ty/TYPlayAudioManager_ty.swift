//
//  TYPlayAudioManager_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation
import AVFoundation

/// 播放音频
@objc(TYPlayAudioManager_ty)
public class TYPlayAudioManager_ty: NSObject {

    @objc
    public static let share_ty = TYPlayAudioManager_ty()

    /// 播放器
    private var player_ty: AVPlayer = AVPlayer()
    /// 播放状态
    @objc
    public var isPlaying_ty: Bool  = false
    /// 资源地址
    private var urlStr_ty: String?

    @objc
    public override init() {
        super.init()
        self.addObservers_ty()
    }

    deinit {
        self.removeObservers_ty()
    }

    /// 播放后回调
    private var playback_ty: DefaultBlock_ty?

    ///播放音频
    @objc
    public func playAudio_ty(url: URL, finishedBlock: DefaultBlock_ty?) {
        TYAuthorizationManager_ty.share_ty.authorizeMicrophoneWith_ty { result in
            if result {
                let item = AVPlayerItem(url: url)
                if item.asset.isPlayable {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback)
                    } catch {
                        print("初始化播放器失败")
                        finishedBlock?()
                        return
                    }
                    if let error = self.player_ty.error {
                        print("播放器加载失败:\(error)")
                        self.player_ty = AVPlayer()
                    }
                    self.playback_ty = finishedBlock
                    self.player_ty.replaceCurrentItem(with: item)
                    self.player_ty.seek(to: .zero)
                    self.player_ty.playImmediately(atRate: 1.0)
                    self.isPlaying_ty = true
                    self.urlStr_ty = url.absoluteString
                } else {
                    kWindow_ty.toast_ty("无效音频")
                    print("无效音频: \(url.absoluteString)")
                    finishedBlock?()
                }
            }
        }
    }

    /// 停止播放
    @objc
    public func stop_ty() {
        if isPlaying_ty {
            self.isPlaying_ty = false
            self.player_ty.pause()
        }
    }

    // MARK: Observer
    /// 添加监听
    private func addObservers_ty() {
    }

    /// 移除监听
    private func removeObservers_ty() {
    }

    // MARK: ==== Notification ====
    /// 播放结束事件
    @objc
    private func playFinished_ty() {
        self.isPlaying_ty = false
        self.playback_ty?()
    }
    
    /// 播放失败
    @objc
    private func playFail_ty() {
        self.playback_ty?()
    }
}
