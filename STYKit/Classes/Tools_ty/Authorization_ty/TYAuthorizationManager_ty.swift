//
//  TYAuthorizationManager_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Photos
import UserNotifications
import UIKit
import Contacts

public enum TYAuthorizationType_ty: String {
    /// 相册
    case photo_ty        = "相册"
    /// 照相机
    case camera_ty       = "照相机"
    /// 麦克风
    case microphone_ty   = "麦克风"
    /// 定位
    case location_ty     = "定位"
    /// 通知
    case notification_ty = "通知"
    /// 网络
    case network_ty      = "网络"
    /// 通讯录
    case contact_ty      = "通讯录"
}

@objc
public class TYAuthorizationManager_ty: NSObject, CLLocationManagerDelegate {
    
    @objc
    public static let share_ty = TYAuthorizationManager_ty()
    
    // MARK: - ---获取相册权限
    @objc
    public func photo_ty(completion:@escaping (Bool) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            completion(false)
            return
        }
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
            self.showAlert_ty(type: .photo_ty)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    let result = status == PHAuthorizationStatus.authorized
                    completion(result)
                    if (!result) {
                        self.showAlert_ty(type: .photo_ty)
                    }
                }
            })
        case .limited:
            completion(true)
        @unknown default:
            return
        }
    }
    
    // MARK: - --相机权限
    public func camera_ty(completion:@escaping (Bool) -> Void ) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
            self.showAlert_ty(type: .camera_ty)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (result: Bool) in
                DispatchQueue.main.async {
                    completion(result)
                    if (!result) {
                        self.showAlert_ty(type: .camera_ty)
                    }
                }
            })
        @unknown default:
            return
        }
    }
    
    // MARK: - --麦克风权限
    public func authorizeMicrophoneWith_ty(completion:@escaping (Bool) -> Void ) {
        
        let status = AVAudioSession.sharedInstance().recordPermission
        
        switch status {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
            self.showAlert_ty(type: .microphone_ty)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (result) in
                DispatchQueue.main.async {
                    completion(result)
                    if (!result) {
                        self.showAlert_ty(type: .microphone_ty)
                    }
                }
            }
        @unknown default:
            return
        }
    }
    
    // MARK: - --远程通知权限
    public func authorizeRemoteNotification_ty(_ completion:@escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .denied || settings.authorizationStatus == .notDetermined {
                    completion(false)
                }else{
                    completion(true)
                }
            }
        }
    }
    
    private var authorizationComplet_ty: BoolBlock_ty?
    // MARK: ==== CLLocationManagerDelegate ====
    
    // TODO: ==== Tools ====
    private func showAlert_ty(type: TYAuthorizationType_ty) {
        let projectName  = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        let title        = String(format: "无法访问你的%@", type.rawValue)
        let description  = String(format: "请到设置 -> %@ -> %@，打开访问权限", projectName, type.rawValue)

        TYAlertManager_ty.share_ty.twoButton_ty(title: title, description: description, leftBtnName: "取消", leftBtnClosure: nil, rightBtnName: "打开") {
            self.jumpToAppSetting_ty()
        }.show_ty()
    }
    
    private func jumpToAppSetting_ty() {
        let appSetting = URL(string: UIApplication.openSettingsURLString)

        if appSetting != nil {
            if #available(iOS 10, *) {
                UIApplication.shared.open(appSetting!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appSetting!)
            }
        }
    }
}

