//
//  AppDelegate.swift
//  STYKit
//
//  Created by 916878440@qq.com on 04/11/2022.
//  Copyright (c) 2022 916878440@qq.com. All rights reserved.
//

import UIKit
import STYKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        TYNetworkConfig_ty.share_ty.domainApi_ty = "http://gwtest.520taliao.com"
        let extJson = self.getHeaderExt_ty()
        TYNetworkConfig_ty.share_ty.headerParameters_ty = [
            "authorization":"",
            "_uid":"",
            "platform":"meetfriend",
            "_ext_":extJson
        ]
        return true
    }
    
    private func getHeaderExt_ty() -> String {
        var extDic = [String:String]()
        extDic["androidId"]      = ""
        extDic["appVersion"]     = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        extDic["appVersionCode"] = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        extDic["channelCode"]    = "98"
        extDic["imei"]           = ""
        extDic["mac"]            = ""
        extDic["oaid"]           = ""
        extDic["packageName"]    = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
        extDic["phoneFirm"]      = "apple"
        extDic["phoneModel"]     = TYDeviceManager_ty.share_ty.model_ty().rawValue
        extDic["phoneSystem"]    = UIDevice.current.systemVersion
        extDic["phoneUuid"]      = TYDeviceManager_ty.share_ty.UUID()
        extDic["source"]         = "IOS"
        return extDic.toJson_ty()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

