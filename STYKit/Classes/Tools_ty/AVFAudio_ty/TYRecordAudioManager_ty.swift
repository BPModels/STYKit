//
//  TYRecordAudioManager_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation
import AVFoundation

/// 录音
@objc(TYRecordAudioManager_tyDelegate)
public protocol TYRecordAudioManagerDelegate_ty: NSObjectProtocol {
    /// 每0.1s刷新一次
    func refreshAction_ty(duration_ty: TimeInterval)
    /// 录制结束
    func recordFinished_ty(data_ty: Data, local_ty path_ty: String, duration_ty: TimeInterval)
    /// 声音回调，每0.1s刷新一次
    func updateVoice_ty(value_ty: Float)
}

/// 声音管理器
@objc(BPAudioManager)
public class TYRecordAudioManager_ty: NSObject, AVAudioRecorderDelegate {

    @objc
    static public let share_ty = TYRecordAudioManager_ty()
    @objc
    public weak var delegate_ty: TYRecordAudioManagerDelegate_ty?

    private let filePath_ty = "/voice.aac"
    
    private var isCancel_ty = false

    /// 录制起
    private var recorder_ty: AVAudioRecorder?

    /// 录制完成回调
    private var recordBlock_ty: ((Data, TimeInterval)->Void)?

    private var timer_ty: Timer?

    /// 刷新间隔时间
    private let interval_ty = 0.25

    /// 当前已录制秒数
    private var currentSecond_ty: TimeInterval = .zero {
        willSet(newValue_ty) {
            self.delegate_ty?.refreshAction_ty(duration_ty: newValue_ty)
        }
    }

    deinit {
        self.stopTimer_ty()
    }

    /// 开始录音
    /// - Parameters:
    ///   - refreshBlock: 当前已录制的时间，默认0.1s回调一次
    ///   - completeBlock: 完成录制，返回录制的音频文件和持续的时间
    @objc
    public func startRecording_ty() {
        self.isCancel_ty      = false
        self.currentSecond_ty = 0
        let session_ty = AVAudioSession.sharedInstance()
        do {
            try session_ty.setCategory(.playAndRecord)
            try session_ty.setActive(true, options: .notifyOthersOnDeactivation)
            var setting_ty = [String:Any]()
            //设置录音格式
            setting_ty[AVFormatIDKey]            = NSNumber(value: kAudioFormatMPEG4AAC)
            //设置录音采样率（HZ）
            setting_ty[AVSampleRateKey]          = NSNumber(value: 44100.0)
            //录音通道数
            setting_ty[AVNumberOfChannelsKey]    = NSNumber(value: 2)
            //线性采样位数
            setting_ty[AVLinearPCMBitDepthKey]   = NSNumber(value: 16)
            //录音的质量
            setting_ty[AVEncoderAudioQualityKey] = NSNumber(value: AVAudioQuality.min.rawValue)

            let url_ty = URL(fileURLWithPath: filePath_ty)
            self.recorder_ty = try AVAudioRecorder(url: url_ty, settings: setting_ty)
            self.recorder_ty?.delegate = self
            //开启音量监测
            self.recorder_ty?.isMeteringEnabled = true
            if self.recorder_ty?.prepareToRecord() ?? false {
                self.recorder_ty?.record()
                self.startTimer_ty()
                print("启动录制成功 _ty")
            } else {
                print("启动录制失败 _ty")
            }
        } catch let error_ty {
            print("\(error_ty)")
        }
    }

    /// 停止录音
    public func stopRecording_ty() {
        self.isCancel_ty = false
        self.recorder_ty?.stop()
    }

    /// 取消录音
    func cancelRecording_ty() {
        self.isCancel_ty = true
        self.recorder_ty?.stop()
    }

    // MARK: ==== Event ====
    private func startTimer_ty() {
        self.timer_ty = Timer.scheduledTimer(withTimeInterval: interval_ty, repeats: true) { [weak self] timer_ty in
            guard let self = self else { return }
            self.currentSecond_ty += self.interval_ty
            self.updateVoice_ty()
            print(self.currentSecond_ty)
        }
        self.timer_ty?.fire()
    }

    private func stopTimer_ty() {
        self.timer_ty?.invalidate()
        self.timer_ty = nil
    }

    private func updateVoice_ty() {
        self.recorder_ty?.updateMeters()
        let voice_ty = self.getVoice_ty()
        print("当前音量\(voice_ty)")
        self.delegate_ty?.updateVoice_ty(value_ty: voice_ty * 10)
    }

    /// 获取音量大小
    /// - Returns: 范围0～1
    private func getVoice_ty() -> Float {
        var level_ty: Float = .zero
        let minV_ty: Float  = -60
        let averageV_ty = self.recorder_ty?.averagePower(forChannel: 0) ?? 0
        if averageV_ty < minV_ty {
            level_ty = .zero
        } else if averageV_ty >= .zero {
            level_ty = 1
        } else {
            let root_ty: Float = 5.0
            let minAmp_ty = powf(10.0, 0.05 * minV_ty)
            let inverseAmpRange_ty = 1.0 / (1.0 - minAmp_ty)
            let amp_ty = powf(10.0, 0.05 * averageV_ty)
            let adjAmp_ty = (amp_ty - minAmp_ty) * inverseAmpRange_ty
            level_ty = powf(adjAmp_ty, 1.0 / root_ty)
        }
        return level_ty
    }
    
    /// 震动
    public func shake_ty() {
    //    AudioServicesPlayAlertSound(1352)
        #if swift(>=5.4)
        if #available(iOS 13, *) {
            if !AVAudioSession.sharedInstance().allowHapticsAndSystemSoundsDuringRecording {
                try? AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
            }
        }
        #endif
        
        let gen_ty = UIImpactFeedbackGenerator(style: .medium)
        gen_ty.prepare()
        gen_ty.impactOccurred()
    }

    // MARK: ==== AVAudioRecorderDelegate ====
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.stopTimer_ty()
        guard let data_ty = try? Data(contentsOf: URL(fileURLWithPath: filePath_ty)) else {
            return
        }
        if !isCancel_ty {
            self.delegate_ty?.recordFinished_ty(data_ty: data_ty, local_ty: filePath_ty, duration_ty: currentSecond_ty)
        }
        self.recorder_ty?.deleteRecording()
    }

    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("error")
    }
}
