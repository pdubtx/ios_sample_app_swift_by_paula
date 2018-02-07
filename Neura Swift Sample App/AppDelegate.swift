//
//  AppDelegate.swift
//  Push Notifications Test
//
//  Created by Neura on 7/10/16.
//  Copyright © 2016 Neura. All rights reserved.
// updated by Paula

import UIKit
import NeuraSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool{
        // Change these values to the ones related to your app (https://dev.theneura.com/console/apps)
        NeuraSDK.shared.appUID = "d17aa5f39d052a42d7e8fce29fd5a7b1f47526339f3f86d08ae66979ad1a4f99"
        NeuraSDK.shared.appSecret = "cc5fe631ff8de1f5359468eb5086c608b7dd97538a8ac70002627b54b753d3e0"
        PushNotifications.requestPermissionForPushNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if NeuraSDKPushNotification.handleNeuraPush(withInfo: userInfo, fetchCompletionHandler: completionHandler) {
            // A remote notificiation, sent from Neura's server was handled by Neura's SDK.
            // The SDK will call the completion handler.
            return
        }
        
        NeuraSDK.shared.appToken()
        
        // Handle here your own remote notifications.
        // It is your responsibility to call the completionHandler.
        completionHandler(.noData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotifications.register(deviceToken: deviceToken)
    }
}
