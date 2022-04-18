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
    public func photo_ty(completion_ty:@escaping (Bool) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            completion_ty(false)
            return
        }
        let status_ty = PHPhotoLibrary.authorizationStatus()
        switch status_ty {
        case .authorized:
            completion_ty(true)
        case .denied, .restricted:
            completion_ty(false)
            self.showAlert_ty(type_ty: .photo_ty)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status_ty) in
                DispatchQueue.main.async {
                    let result_ty = status_ty == PHAuthorizationStatus.authorized
                    completion_ty(result_ty)
                    if (!result_ty) {
                        self.showAlert_ty(type_ty: .photo_ty)
                    }
                }
            })
        case .limited:
            completion_ty(true)
        @unknown default:
            return
        }
    }
    
    // MARK: - --相机权限
    public func camera_ty(completion_ty:@escaping (Bool) -> Void ) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        let status_ty = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status_ty {
        case .authorized:
            completion_ty(true)
        case .denied, .restricted:
            completion_ty(false)
            self.showAlert_ty(type_ty: .camera_ty)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (result_ty: Bool) in
                DispatchQueue.main.async {
                    completion_ty(result_ty)
                    if (!result_ty) {
                        self.showAlert_ty(type_ty: .camera_ty)
                    }
                }
            })
        @unknown default:
            return
        }
    }
    
    // MARK: - --麦克风权限
    public func authorizeMicrophoneWith_ty(completion_ty:@escaping (Bool) -> Void ) {
        
        let status_ty = AVAudioSession.sharedInstance().recordPermission
        
        switch status_ty {
        case .granted:
            completion_ty(true)
        case .denied:
            completion_ty(false)
            self.showAlert_ty(type_ty: .microphone_ty)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (result_ty) in
                DispatchQueue.main.async {
                    completion_ty(result_ty)
                    if (!result_ty) {
                        self.showAlert_ty(type_ty: .microphone_ty)
                    }
                }
            }
        @unknown default:
            return
        }
    }
    
    // MARK: - --远程通知权限
    public func authorizeRemoteNotification_ty(_ completion_ty:@escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings_ty) in
            DispatchQueue.main.async {
                if settings_ty.authorizationStatus == .denied || settings_ty.authorizationStatus == .notDetermined {
                    completion_ty(false)
                }else{
                    completion_ty(true)
                }
            }
        }
    }
    
    private var authorizationComplet_ty: BoolBlock_ty?
    // MARK: ==== CLLocationManagerDelegate ====
    
    // TODO: ==== Tools ====
    private func showAlert_ty(type_ty: TYAuthorizationType_ty) {
        let projectName_ty  = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        let title_ty        = String(format: "无法访问你的%@", type_ty.rawValue)
        let description_ty  = String(format: "请到设置 -> %@ -> %@，打开访问权限", projectName_ty, type_ty.rawValue)

        TYAlertManager_ty.share_ty.twoButton_ty(title_ty: title_ty, description_ty: description_ty, leftBtnName_ty: "取消", leftBtnClosure_ty: nil, rightBtnName_ty: "打开") {
            self.jumpToAppSetting_ty()
        }.show_ty()
    }
    
    /// 跳转到App设置页面
    private func jumpToAppSetting_ty() {
        let appSetting_ty = URL(string: UIApplication.openSettingsURLString)

        if appSetting_ty != nil {
            if #available(iOS 10, *) {
                UIApplication.shared.open(appSetting_ty!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appSetting_ty!)
            }
        }
    }
}

