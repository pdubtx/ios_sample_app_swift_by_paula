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
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool{
    NeuraSDK.sharedInstance().appUID = "611c657ba5e3b0a9b705d0fc7047a233f36d08da7182975a97aab54f7fd40cd0"
    NeuraSDK.sharedInstance().appSecret = "162fc1785119471712153a0344fe6d0dbff4ede9a0e1f04ee66be89c6070bc07"
    
    /*
     Here we register for push notifications and attach a method to respond.
     In this case, we're just popping up an alert.
     If you need to see the device token for testing purposes, you can use the
     "NeuraSDKPushNotification.getDeviceToken()" method.
    */
    NeuraSDKPushNotification.enableAutomaticPushNotification()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(respondToPush), name: "NeuraSDKDidReceiveRemoteNotification", object: nil)
    return true
  }
  
  @objc func respondToPush(notification: NSNotification) {
    var alertController: UIAlertController
    alertController = UIAlertController(title: "Push message", message: nil, preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(okAction)
    
    var targetVC = self.window?.rootViewController
    while targetVC?.presentedViewController != nil {
        targetVC = targetVC?.presentedViewController
    }
    targetVC!.presentViewController(alertController, animated: true, completion: nil)
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}