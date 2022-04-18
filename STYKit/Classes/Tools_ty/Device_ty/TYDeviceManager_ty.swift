//
//  TYDeviceManager_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/15.
//

import Foundation
import CoreTelephony

public struct TYDeviceManager_ty {
    public static let share_ty = TYDeviceManager_ty()
    
    public func UUID_ty() -> String {
        var uuid_ty      = ""
        let kDataUUID_ty = Bundle.main.bundleIdentifier ?? ""
        let kTextUUID_ty = "UUID_TEXT_ty"
        let dictUUID_ty  = TYKeyChainManager_ty.load(kDataUUID_ty) as? [String:Any] ?? [:]
        if dictUUID_ty.keys.contains(kTextUUID_ty) {
            // 如果keychain中存在
            uuid_ty = dictUUID_ty[kTextUUID_ty] as? String ?? ""
        } else {
            // 如果不存在
            uuid_ty = UIDevice.current.identifierForVendor?.uuidString ?? ""
            TYKeyChainManager_ty.save(kDataUUID_ty, data_ty: [kTextUUID_ty:uuid_ty])
        }
        
        return uuid_ty
    }
    /// 设备型号
    public func model_ty() -> DeviceModelType {
        var size_ty: Int = 0
        sysctlbyname("hw.machine", nil, &size_ty, nil, 0)
        var machine_ty: [CChar] = [CChar](repeating: 0, count: size_ty)
        sysctlbyname("hw.machine", &machine_ty, &size_ty, nil, 0)
        let platform_ty = String(cString: machine_ty)
        switch platform_ty {
        // iPhone
        case "iPhone1,1":                           return .iPhone1_ty
        case "iPhone1,2":                           return .iPhone3g_ty
        case "iPhone2,1":                           return .iPhone3gs_ty
        case "iPhone3,1","iPhone3,2","iPhone3,3":   return .iPhone4_ty
        case "iPhone4,1":                           return .iPhone4s_ty
        case "iPhone5,1","iPhone5,2":               return .iPhone5_ty
        case "iPhone5,3","iPhone5,4":               return .iPhone5c_ty
        case "iPhone6,1","iPhone6,2":               return .iPhone5s_ty
        case "iPhone7,1":                           return .iPhone6plus_ty
        case "iPhone7,2":                           return .iPhone6_ty
        case "iPhone8,1":                           return .iPhone6s_ty
        case "iPhone8,2":                           return .iPhone6sPlus_ty
        case "iPhone8,4":                           return .iPhoneSE_ty
        case "iPhone9,1","iPhone9,3":               return .iPhone7_ty
        case "iPhone9,2","iPhone9,4":               return .iPhone7plus_ty
        case "iPhone10,1","iPhone10,4":             return .iPhone8_ty
        case "iPhone10,2","iPhone10,5":             return .iPhone8Plus_ty
        case "iPhone10,3","iPhone10,6":             return .iPhoneX_ty
        case "iPhone11,8":                          return .iPhoneXr_ty
        case "iPhone11,2":                          return .iPhoneXs_ty
        case "iPhone11,6":                          return .iPhoneXsMax_ty
        case "iPhone12,1":                          return .iPhone11_ty
        case "iPhone12,3":                          return .iPhone11Pro_ty
        case "iPhone12,5":                          return .iPhone11ProMax_ty
        case "iPhone12,8":                          return .iPhoneSE2_ty
        case "iPhone13,1":                          return .iPhone12Mini_ty
        case "iPhone13,2":                          return .iPhone12_ty
        case "iPhone13,3":                          return .iPhone12Pro_ty
        case "iPhone13,4":                          return .iPhone12ProMax_ty
        case "iPhone14,4":                          return .iPhone13Mini_ty
        case "iPhone14,5":                          return .iPhone13_ty
        case "iPhone14,2":                          return .iPhone13Pro_ty
        case "iPhone14,3":                          return .iPhone13ProMax_ty
        case "iPhone14,6":                          return .iPhoneSE3_ty
        // iPod Touch
        case "iPod1,1": return .iPodTouch1_ty
        case "iPod2,1": return .iPodTouch2_ty
        case "iPod3,1": return .iPodTouch3_ty
        case "iPod4,1": return .iPodTouch4_ty
        case "iPod5,1": return .iPodTouch5_ty
        case "iPod7,1": return .iPodTouch6_ty
        case "iPod9,1": return .iPodTouch7_ty
        // iPad mini
        case "iPad2,5","iPad2,6","iPad2,7": return .iPadMini1_ty
        case "iPad4,4","iPad4,5","iPad4,6": return .iPadMini2_ty
        case "iPad4,7","iPad4,8","iPad4,9": return .iPadMini3_ty
        case "iPad5,1","iPad5,2":           return .iPadMini4_ty
        case "iPad11,1","iPad11,2":         return .iPadMini5_ty
        case "iPad14,1","iPad14,2":         return .iPadMini6_ty
        // iPad
        case "iPad1,1":                                 return .iPad1_ty
        case "iPad2,1","iPad2,2","iPad2,3","iPad2,4":   return .iPad2_ty
        case "iPad3,1","iPad3,2","iPad3,3":             return .iPad3_ty
        case "iPad3,4","iPad3,5","iPad3,6":             return .iPad4_ty
        case "iPad6,11","iPad6,12":                     return .iPad5_ty
        case "iPad7,5","iPad7,6":                       return .iPad6_ty
        case "iPad7,12", "iPad7,11":                    return .iPad7_ty
        case "iPad11,7","iPad11,6":                     return .iPad8_ty
        case "iPad12,1","iPad12,2":                     return .iPad9_ty
        // iPad Air
        case "iPad4,1","iPad4,2","iPad4,3": return .iPadAir1_ty
        case "iPad5,3","iPad5,4":           return .iPadAir2_ty
        case "iPad11,3","iPad11,4":         return .iPadAir3_ty
        case "iPad13,1","iPad13,2":         return .iPadAir4_ty
        case "iPad13,16","iPad13,17":       return .iPadAir5_ty
        // iPad Pro
        case "iPad6,7","iPad6,8":                           return .iPadPro_12Inch_ty
        case "iPad6,3","iPad6,4":                           return .iPadPro_9Inch_ty
        case "iPad7,3","iPa7,4":                            return .iPadPro_10Inch_ty
        case "iPad8,1","iPad8,2","iPad8,3","iPad8,4":       return .iPadPro_11Inch_ty
        case "iPad7,1","iPad7,2":                           return .iPadPro2_12Inch_ty
        case "iPad8,9","iPad8,10":                          return.iPadPro2_11Inch_ty
        case "iPad8,5","iPad8,6","iPad8,7","iPad8,8":       return .iPadPro3_12Inch_ty
        case "iPad13,4","iPad13,5","iPad13,6","iPad13,7":   return .iPadPro3_11Inch_ty
        case "iPad8,11","iPad8,12":                         return .iPadPro4_12Inch_ty
        case "iPad13,8","iPad13,9","iPad13,10","iPad13,11": return .iPadPro5_129Inch_ty
        // Apple Watch
        case "Watch1,1","Watch1,2":                          return .appleWatch_ty
        case "Watch2,6","Watch2,7":                          return .appleWatch1_ty
        case "Watch2,3","Watch2,4":                          return .appleWatch2_ty
        case "Watch3,1","Watch3,2","Watch3,3","Watch3,4":    return .appleWatch3_ty
        case "Watch4,1","Watch4,2","Watch4,3","Watch4,4":    return .appleWatch4_ty
        case "Watch5,3","Watch5,4":                          return .appleWatch5_ty
        case "Watch5,9","Watch5,10","Watch5,11","Watch5,12": return .appleWatchSE_ty
        case "Watch6,1","Watch6,2","Watch6,3","Watch6,4":    return .appleWatch6_ty
        case "Watch6,6","Watch6,7","Watch6,8","Watch6,9":    return .appleWatch7_ty
        // Apple TV
        case "AppleTV2,1":              return .appleTV2_ty
        case "AppleTV3,1","AppleTV3,2": return .appleTV3_ty
        case "AppleTV5,3":              return .appleTV4_ty
        case "AppleTV6,2":              return .appleTV4K_ty
        case "AppleTV11,1":             return .appleTV4K2_ty
        // AirPods
        case "AirPods1,1":                              return .airPods1_ty
        case "AirPods2,1":                              return .airPods2_ty
        case "AirPods1,3","Audio2,1":                   return .airPods3_ty
        case "AirPods2,2","AirPodsPro1,1","iProd8,1":   return .airPodsPro_ty
        case "AirPodsMax1,1","iProd8,6":                return .airPodsMax_ty
        // HomePod
        case "AudioAccessory1,1","AudioAccessory1,2": return .homePod_ty
        case "AudioAccessory5,1":                     return .homePodMini_ty
        // Simulator
        case "i386","x86_64": return .simulator_ty
        default: return .newDevice_ty
        }
    }
    
    /// 定义苹果设备的枚举类型
    public enum DeviceModelType: String {
        // iPhone
        case iPhone1_ty        = "iPhone 1g"
        case iPhone3g_ty       = "iPhone 3g"
        case iPhone3gs_ty      = "iPhone 3gs"
        case iPhone4_ty        = "iPhone 4"
        case iPhone4s_ty       = "iPhone 4s"
        case iPhone5_ty        = "iPhone 5"
        case iPhone5c_ty       = "iPhone 5c"
        case iPhone5s_ty       = "iPhone 5s"
        case iPhone6plus_ty    = "iPhone 6 Plus"
        case iPhone6_ty        = "iPhone 6"
        case iPhone6s_ty       = "iPhone 6s"
        case iPhone6sPlus_ty   = "iPhone 6s Plus"
        case iPhoneSE_ty       = "iPhone SE (1st generation)"
        case iPhone7_ty        = "iPhone 7"
        case iPhone7plus_ty    = "iPhone 7 Plus"
        case iPhone8_ty        = "iPhone 8"
        case iPhone8Plus_ty    = "iPhone 8 Plus"
        case iPhoneX_ty        = "iPhone X"
        case iPhoneXr_ty       = "iPhone Xr"
        case iPhoneXs_ty       = "iPhone Xs"
        case iPhoneXsMax_ty    = "iPhone Xs Max"
        case iPhone11_ty       = "iPhone 11"
        case iPhone11Pro_ty    = "iPhone 11 Pro"
        case iPhone11ProMax_ty = "iPhone 11 Pro Max"
        case iPhoneSE2_ty      = "iPhone SE (2nd generation)"
        case iPhone12Mini_ty   = "iPhone 12 mini"
        case iPhone12_ty       = "iPhone 12"
        case iPhone12Pro_ty    = "iPhone 12 Pro"
        case iPhone12ProMax_ty = "iPhone 12 Pro Max"
        case iPhone13Mini_ty   = "iPhone 13 mini"
        case iPhone13_ty       = "iPhone 13"
        case iPhone13Pro_ty    = "iPhone 13 Pro"
        case iPhone13ProMax_ty = "iPhone 13 Pro Max"
        case iPhoneSE3_ty      = "iPhone SE (3rd generation)"
        // iPod
        case iPodTouch1_ty = "iPod touch"
        case iPodTouch2_ty = "iPod touch (2nd generation)"
        case iPodTouch3_ty = "iPod touch (3rd generation)"
        case iPodTouch4_ty = "iPod touch (4th generation)"
        case iPodTouch5_ty = "iPod touch (5th generation)"
        case iPodTouch6_ty = "iPod touch (6th generation)"
        case iPodTouch7_ty = "iPod touch (7th generation)"
        // iPad mini
        case iPadMini1_ty = "iPad mini"
        case iPadMini2_ty = "iPad mini 2"
        case iPadMini3_ty = "iPad mini 3"
        case iPadMini4_ty = "iPad mini 4"
        case iPadMini5_ty = "iPad mini (5th generation)"
        case iPadMini6_ty = "iPad mini (6th generation)"
        // iPad Series
        case iPad1_ty = "iPad"
        case iPad2_ty = "iPad 2"
        case iPad3_ty = "iPad (3rd generation)"
        case iPad4_ty = "iPad (4th generation)"
        case iPad5_ty = "iPad (5th generation)"
        case iPad6_ty = "iPad (6th generation)"
        case iPad7_ty = "iPad (7th generation)"
        case iPad8_ty = "iPad (8th generation)"
        case iPad9_ty = "iPad (9th generation)"
        // iPad Pro
        case iPadPro_9Inch_ty      = "iPad Pro (9.7-inch)"
        case iPadPro_10Inch_ty     = "iPad Pro (10.5-inch)"
        case iPadPro_11Inch_ty     = "iPad Pro (11-inch)"
        case iPadPro_12Inch_ty     = "iPad Pro (12.9-inch)"
        case iPadPro2_11Inch_ty    = "iPad Pro (11-inch) (2nd generation)"
        case iPadPro2_12Inch_ty    = "iPad Pro (12.9-inch) (2nd generation)"
        case iPadPro3_11Inch_ty    = "iPad Pro (11-inch) (3rd generation)"
        case iPadPro3_12Inch_ty    = "iPad Pro (12.9-inch) (3rd generation)"
        case iPadPro4_12Inch_ty    = "iPad Pro (12.9-inch) (4th generation)"
        case iPadPro5_129Inch_ty   = "iPad Pro (12.9-inch) (5th generation)"
        // iPad Air
        case iPadAir1_ty = "iPad Air"
        case iPadAir2_ty = "iPad Air 2"
        case iPadAir3_ty = "iPad Air (3rd generation)"
        case iPadAir4_ty = "iPad Air (4th generation)"
        case iPadAir5_ty = "iPad Air (5th generation)"
        // Apple Watch
        case appleWatch_ty   = "Apple Watch (1st generation)"
        case appleWatch1_ty  = "Apple Watch Series 1"
        case appleWatch2_ty  = "Apple Watch Series 2"
        case appleWatch3_ty  = "Apple Watch Series 3"
        case appleWatch4_ty  = "Apple Watch Series 4"
        case appleWatch5_ty  = "Apple Watch Series 5"
        case appleWatchSE_ty = "Apple Watch SE"
        case appleWatch6_ty  = "Apple Watch Series 6"
        case appleWatch7_ty  = "Apple Watch Series 7"
        // Apple TV
        case appleTV2_ty   = "Apple TV (2nd generation)"
        case appleTV3_ty   = "Apple TV (3rd generation)"
        case appleTV4_ty   = "Apple TV (4th generation)"
        case appleTV4K_ty  = "AppleTV6,2"
        case appleTV4K2_ty = "Apple TV 4K (2nd generation)"
        // AirPods
        case airPods1_ty   = "AirPods (1st generation)"
        case airPods2_ty   = "AirPods (2nd generation)"
        case airPods3_ty   = "AirPods (3rd generation)"
        case airPodsPro_ty = "AirPods Pro"
        case airPodsMax_ty = "AirPods Max"
        // HomePod
        case homePod_ty     = "HomePod"
        case homePodMini_ty = "HomePod mini"
        // Simulator
        case simulator_ty = "simulator"
        case newDevice_ty = ""
    }

}

