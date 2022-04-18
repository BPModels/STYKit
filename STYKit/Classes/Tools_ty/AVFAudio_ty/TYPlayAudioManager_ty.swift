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
    public func playAudio_ty(url_ty: URL, finishedBlock_ty: DefaultBlock_ty?) {
        TYAuthorizationManager_ty.share_ty.authorizeMicrophoneWith_ty { result_ty in
            if result_ty {
                let item_ty = AVPlayerItem(url: url_ty)
                if item_ty.asset.isPlayable {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback)
                    } catch {
                        print("初始化播放器失败_ty")
                        finishedBlock_ty?()
                        return
                    }
                    if let error_ty = self.player_ty.error {
                        print("播放器加载失败:\(error_ty)_ty")
                        self.player_ty = AVPlayer()
                    }
                    self.playback_ty = finishedBlock_ty
                    self.player_ty.replaceCurrentItem(with: item_ty)
                    self.player_ty.seek(to: .zero)
                    self.player_ty.playImmediately(atRate: 1.0)
                    self.isPlaying_ty = true
                    self.urlStr_ty    = url_ty.absoluteString
                } else {
                    kWindow_ty.toast_ty("无效音频_ty")
                    print("无效音频: \(url_ty.absoluteString)")
                    finishedBlock_ty?()
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
