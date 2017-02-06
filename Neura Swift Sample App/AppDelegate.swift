//
//  AppDelegate.swift
//  Push Notifications Test
//
//  Created by Beau Harper on 7/10/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import UIKit
import NeuraSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool{
    NeuraSDK.shared.appUID = "ee01346c01f64c5345f21830d9ca91dde0046db1442c6b8932e60a77f32d8d17"
    NeuraSDK.shared.appSecret = "4a56d9a3c4b8dad1ebd4dd4978dc8a0bac4d6eaabab35f7bee7bfea2ae3722c3"
    
    /*
     Here we register for push notifications and attach a method to respond.
     In this case, we're just popping up an alert.
     If you need to see the device token for testing purposes, you can use the
     "NeuraSDKPushNotification.getDeviceToken()" method.
    */
    NeuraSDKPushNotification.enableAutomaticPushNotification()
    NotificationCenter.default.addObserver(self, selector: #selector(respondToPush), name: NSNotification.Name(rawValue: "NeuraSDKDidReceiveRemoteNotification"), object: nil)
    return true
  }
    
  @objc func respondToPush(_ notification: Notification) {
    let alertController = UIAlertController(title: "Push message", message: nil, preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    var targetVC = self.window?.rootViewController
    while targetVC?.presentedViewController != nil {
        targetVC = targetVC?.presentedViewController
    }
    targetVC!.present(alertController, animated: true, completion: nil)
  }
}
