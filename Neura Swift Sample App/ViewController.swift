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
  
  let userDefaults = UserDefaults.standard
  
  //MARK: Lifecycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.layer.borderWidth = 1
    loginButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    if userDefaults.bool(forKey: "kIsUserLogin") {
      neuraConnectSymbolAnimate()
    } else {
      neuraDisconnectSymbolAnimate()
    }
    //Get the SDK version
    let sdkVersion = (neuraSDK?.getVersion())! as String
    let sdkText = "SDK Version: \(sdkVersion)"
    self.sdkVersionLabel.text = sdkText
    
    let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
    let appVersion = nsObject as! String
    self.appVersionLabel.text = appVersion
    
  }
  
  //MARK: Login/Logout Functions
  func logoutFromNeura(){
    neuraSDK?.logout()
    userDefaults.set(false, forKey: "kIsUserLogin")
    self.neuraDisconnectSymbolAnimate()
  }
  
  func loginToNeura(){
    /*
     Specify your permissions array in an NSArray. These can be found in the the developer
     console under "Permissions."
     */
    let permissions: Array = [
        "presenceAtHome",
        "physicalActivity"
    ]
    /*This logs the user in. In this case, we're saving a bool to userDefaults to indicate that the user is logged in.
    Your implementation may be different
 */
    
    neuraSDK?.authenticate(withPermissions: permissions as [String], userInfo: nil, on: self, withHandler: { (token, error) in
      if token != nil {
        self.userDefaults.set(true, forKey: "kIsUserLogin")
        self.neuraStatusLabel.text = "Connected"
        self.neuraStatusLabel.textColor = UIColor.green
        self.loginButton.setTitle("Disconnect", for: .normal)
        self.neuraConnectSymbolAnimate()
      }else{
        print("login error = \(error)")
      }
    })
  }
  
  //MARK: Symbol Animation Functions
  func neuraConnectSymbolAnimate() {
    let topTransformation = CGAffineTransform.identity
    let bottomTransformation = CGAffineTransform.identity
    UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseIn, animations: {
      self.neuraSymbolTop.transform = topTransformation
      self.neuraSymbolBottom.transform = bottomTransformation
      self.neuraSymbolTop.alpha = 1
      self.neuraSymbolBottom.alpha = 1
    }) { (finished) in
      self.neuraStatusLabel.text = "Connected"
      self.neuraStatusLabel.textColor = UIColor.green
      self.loginButton.setTitle("Disconnect", for: UIControlState())
      self.permissionsListButton.setTitle("Edit Subscriptions", for: UIControlState())
    }
  }
  
  func neuraDisconnectSymbolAnimate() {
    let topTransformation = CGAffineTransform(translationX: -20, y: 0)
    let bottomTransformation = CGAffineTransform(translationX: 20, y: 0)
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
      self.neuraSymbolTop.transform = topTransformation
      self.neuraSymbolBottom.transform = bottomTransformation
      self.neuraSymbolTop.alpha = 0.2
      self.neuraSymbolBottom.alpha = 0.2
    }) { (finished) in
      self.neuraStatusLabel.text = "Disconnected"
      self.neuraStatusLabel.textColor = UIColor.red
      self.loginButton.setTitle("Connect and request permissions", for: UIControlState())
      self.permissionsListButton.setTitle("Permissions List", for: UIControlState())
    }
  }
  
  //MARK: IBAction Functions
  @IBAction func loginButtonPressed(_ sender: AnyObject) {
    if userDefaults.bool(forKey: "kIsUserLogin") {
      self.logoutFromNeura()
      self.loginButton.setTitle("Connect and request permissions", for: UIControlState())
    } else {
      self.loginToNeura()
    }
  }
  
  @IBAction func approvedPermissionsListButtonPressed(_ sender: AnyObject) {
    //openNeuraSettingsPanel shows the approved permissions. This is a view inside of the SDK
    if userDefaults.bool(forKey: "kIsUserLogin") {
      neuraSDK?.openNeuraSettingsPanel()
    } else{
      let alertController = UIAlertController(title: "The user is not logged in", message: nil, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(okAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  @IBAction func permissionsListButtonPressed(_ sender: AnyObject) {
    if self.permissionsListButton.titleLabel!.text! == "Permissions List" {
      self.performSegue(withIdentifier: "permissionsList", sender: self)
    }
    else {
      self.performSegue(withIdentifier: "subscriptionsList", sender: self)
    }
  }
  
  @IBAction func devicesButtonPressed(_ sender: AnyObject) {
    if userDefaults.bool(forKey: "kIsUserLogin") {
      self.performSegue(withIdentifier: "deviceOperations", sender: self)
    }
    else {
      let alertController = UIAlertController(title: "The user is not logged in", message: nil, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(okAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  @IBAction func sendLogPressed(_ sender: AnyObject) {
    NotificationCenter.default.post(name: Notification.Name(rawValue: "NeuraSdkPrivateSendLogByMailNotification"), object: nil)
  }
}
