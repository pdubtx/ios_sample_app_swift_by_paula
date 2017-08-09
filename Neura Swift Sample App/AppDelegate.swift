//
//  AppDelegate.swift
//  Push Notifications Test
//
//  Created by Neura on 7/10/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import UIKit
import NeuraSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool{
        // Change these values to the ones related to your app (https://dev.theneura.com/console/apps)
        NeuraSDK.shared.appUID = "ee01346c01f64c5345f21830d9ca91dde0046db1442c6b8932e60a77f32d8d17"
        NeuraSDK.shared.appSecret = "4a56d9a3c4b8dad1ebd4dd4978dc8a0bac4d6eaabab35f7bee7bfea2ae3722c3"
        PushNotifications.requestPermissionForPushNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if NeuraSDKPushNotification.handleNeuraPush(withInfo: userInfo, fetchCompletionHandler: completionHandler) {
            // A remote notificiation, sent from Neura's server was handled by Neura's SDK.
            // The SDK will call the completion handler.
            return
        }
        
        // Handle here your own remote notifications.
        // It is your responsibility to call the completionHandler.
        completionHandler(.noData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotifications.register(deviceToken: deviceToken)
    }
}
