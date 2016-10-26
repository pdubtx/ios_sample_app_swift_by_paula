//
//  ViewController.swift
//  Push Notifications Test
//
//  Created by Beau Harper on 7/10/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import UIKit
import NeuraSDK

class ViewController: UIViewController {
  
  //MARK: Properties
  let neuraSDK = NeuraSDK.sharedInstance()
  
  //MARK: IBOutlets
  @IBOutlet weak var loginButton: RoundedButton!
  @IBOutlet weak var approvedPermissionsListButton: RoundedButton!
  @IBOutlet weak var permissionsListButton: RoundedButton!
  @IBOutlet weak var devicesButton: RoundedButton!
  
  @IBOutlet weak var sdkVersionLabel: UILabel!
  @IBOutlet weak var neuraStatusLabel: UILabel!
  @IBOutlet weak var appVersionLabel: UILabel!
  
  @IBOutlet weak var neuraSymbolTop: UIImageView!
  @IBOutlet weak var neuraSymbolBottom: UIImageView!
  
  let userDefaults = NSUserDefaults.standardUserDefaults()
  
  //MARK: Lifecycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.layer.borderWidth = 1
    loginButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).CGColor
    if userDefaults.boolForKey("kIsUserLogin") {
      neuraConnectSymbolAnimate()
    } else {
      neuraDisconnectSymbolAnimate()
    }
    //Get the SDK version
    let sdkVersion = (neuraSDK.getVersion())! as String
    let sdkText = "SDK Version: \(sdkVersion)"
    self.sdkVersionLabel.text = sdkText
    
    let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
    let appVersion = nsObject as! String
    self.appVersionLabel.text = appVersion
    
  }
  
  //MARK: Login/Logout Functions
  func logoutFromNeura(){
    neuraSDK.logout()
    userDefaults.setBool(false, forKey: "kIsUserLogin")
    self.neuraDisconnectSymbolAnimate()
  }
  
  func loginToNeura(){
    /*
     Specify your permissions array in an NSArray. These can be found in the the developer
     console under "Permissions."
     */
    let permissions: Array = ["userLeftWork", "userLeftHome"]
    /*This logs the user in. In this case, we're saving a bool to userDefaults to indicate that the user is logged in.
    Your implementation may be different
 */
    neuraSDK.authenticateWithPermissions(permissions as [AnyObject], onController: self, withHandler: { (token, error) -> Void in
      if token != nil {
        self.userDefaults.setBool(true, forKey: "kIsUserLogin")
        self.neuraStatusLabel.text = "Connected"
        self.neuraStatusLabel.textColor = UIColor.greenColor()
        self.loginButton.setTitle("Disconnect", forState: .Normal)
        self.neuraConnectSymbolAnimate()
      }else{
        print("login error = \(error)")
      }
    })
  }
  
  //MARK: Symbol Animation Functions
  func neuraConnectSymbolAnimate() {
    let topTransformation = CGAffineTransformIdentity
    let bottomTransformation = CGAffineTransformIdentity
    UIView.animateWithDuration(0.4, delay: 0.1, options: .CurveEaseIn, animations: {
      self.neuraSymbolTop.transform = topTransformation
      self.neuraSymbolBottom.transform = bottomTransformation
      self.neuraSymbolTop.alpha = 1
      self.neuraSymbolBottom.alpha = 1
    }) { (finished) in
      self.neuraStatusLabel.text = "Connected"
      self.neuraStatusLabel.textColor = UIColor.greenColor()
      self.loginButton.setTitle("Disconnect", forState: .Normal)
      self.permissionsListButton.setTitle("Edit Subscriptions", forState: .Normal)
    }
  }
  
  func neuraDisconnectSymbolAnimate() {
    let topTransformation = CGAffineTransformMakeTranslation(-20, 0)
    let bottomTransformation = CGAffineTransformMakeTranslation(20, 0)
    UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: {
      self.neuraSymbolTop.transform = topTransformation
      self.neuraSymbolBottom.transform = bottomTransformation
      self.neuraSymbolTop.alpha = 0.2
      self.neuraSymbolBottom.alpha = 0.2
    }) { (finished) in
      self.neuraStatusLabel.text = "Disconnected"
      self.neuraStatusLabel.textColor = UIColor.redColor()
      self.loginButton.setTitle("Connect and request permissions", forState: .Normal)
      self.permissionsListButton.setTitle("Permissions List", forState: .Normal)
    }
  }
  
  //MARK: IBAction Functions
  @IBAction func loginButtonPressed(sender: AnyObject) {
    if userDefaults.boolForKey("kIsUserLogin") {
      self.logoutFromNeura()
      self.loginButton.setTitle("Connect and request permissions", forState: .Normal)
    } else {
      self.loginToNeura()
    }
  }
  
  @IBAction func approvedPermissionsListButtonPressed(sender: AnyObject) {
    //openNeuraSettingsPanel shows the approved permissions. This is a view inside of the SDK
    if userDefaults.boolForKey("kIsUserLogin") {
      neuraSDK.openNeuraSettingsPanel()
    } else{
      let alertController = UIAlertController(title: "The user is not logged in", message: nil, preferredStyle: .Alert)
      let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
      alertController.addAction(okAction)
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  @IBAction func permissionsListButtonPressed(sender: AnyObject) {
    if self.permissionsListButton.titleLabel!.text! == "Permissions List" {
      self.performSegueWithIdentifier("permissionsList", sender: self)
    }
    else {
      self.performSegueWithIdentifier("subscriptionsList", sender: self)
    }
  }
  
  @IBAction func devicesButtonPressed(sender: AnyObject) {
    if userDefaults.boolForKey("kIsUserLogin") {
      self.performSegueWithIdentifier("deviceOperations", sender: self)
    }
    else {
      let alertController = UIAlertController(title: "The user is not logged in", message: nil, preferredStyle: .Alert)
      let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
      alertController.addAction(okAction)
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  @IBAction func sendLogPressed(sender: AnyObject) {
    NSNotificationCenter.defaultCenter().postNotificationName("NeuraSdkPrivateSendLogByMailNotification", object: nil)
  }
}
