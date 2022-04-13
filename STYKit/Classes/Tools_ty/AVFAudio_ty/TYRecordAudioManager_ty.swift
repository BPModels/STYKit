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
    func refreshAction_ty(duration: TimeInterval)
    /// 录制结束
    func recordFinished_ty(data: Data, local path: String, duration: TimeInterval)
    /// 声音回调，每0.1s刷新一次
    func updateVoice_ty(value: Float)
}

/// 声音管理器
@objc(BPAudioManager)
open class TYRecordAudioManager_ty: NSObject, AVAudioRecorderDelegate {

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
        willSet {
            self.delegate_ty?.refreshAction_ty(duration: newValue)
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
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            var setting = [String:Any]()
            //设置录音格式
            setting[AVFormatIDKey]            = NSNumber(value: kAudioFormatMPEG4AAC)
            //设置录音采样率（HZ）
            setting[AVSampleRateKey]          = NSNumber(value: 44100.0)
            //录音通道数
            setting[AVNumberOfChannelsKey]    = NSNumber(value: 2)
            //线性采样位数
            setting[AVLinearPCMBitDepthKey]   = NSNumber(value: 16)
            //录音的质量
            setting[AVEncoderAudioQualityKey] = NSNumber(value: AVAudioQuality.min.rawValue)

            let url = URL(fileURLWithPath: filePath_ty)
            self.recorder_ty = try AVAudioRecorder(url: url, settings: setting)
            self.recorder_ty?.delegate = self
            //开启音量监测
            self.recorder_ty?.isMeteringEnabled = true
            if self.recorder_ty?.prepareToRecord() ?? false {
                self.recorder_ty?.record()
                self.startTimer_ty()
                print("启动录制成功")
            } else {
                print("启动录制失败")
            }
        } catch let error {
            print("\(error)")
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
        self.timer_ty = Timer.scheduledTimer(withTimeInterval: interval_ty, repeats: true) { [weak self] timer in
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
        let voice = self.getVoice_ty()
        print("当前音量\(voice)")
        self.delegate_ty?.updateVoice_ty(value: voice * 10)
    }

    /// 获取音量大小
    /// - Returns: 范围0～1
    private func getVoice_ty() -> Float {
        var level: Float = .zero
        let minV: Float  = -60
        let averageV = self.recorder_ty?.averagePower(forChannel: 0) ?? 0
        if averageV < minV {
            level = .zero
        } else if averageV >= .zero {
            level = 1
        } else {
            let root: Float = 5.0
            let minAmp = powf(10.0, 0.05 * minV)
            let inverseAmpRange = 1.0 / (1.0 - minAmp)
            let amp = powf(10.0, 0.05 * averageV)
            let adjAmp = (amp - minAmp) * inverseAmpRange
            level = powf(adjAmp, 1.0 / root)
        }
        return level
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
        
        let gen = UIImpactFeedbackGenerator(style: .medium)
        gen.prepare()
        gen.impactOccurred()
    }

    // MARK: ==== AVAudioRecorderDelegate ====
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.stopTimer_ty()
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath_ty)) else {
            return
        }
        if !isCancel_ty {
            self.delegate_ty?.recordFinished_ty(data: data, local: filePath_ty, duration: currentSecond_ty)
        }
        self.recorder_ty?.deleteRecording()
    }

    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("error")
    }
}
