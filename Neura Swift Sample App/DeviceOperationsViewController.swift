//
//  DeviceOperationsViewController.swift
//  Push Notifications Test
//
//  Created by Beau Harper on 7/15/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import Foundation
import UIKit
import NeuraSDK

class DeviceOperationsViewController: UIViewController, PickerDelegate {
  
  //MARK: Properties
  let neuraSDK = NeuraSDK.sharedInstance()
  enum buttonTouched {
    case getAllCapabilities
    case getAllDevices
  }
  weak var pickerVC: PickerViewController?
  var sendingButton:buttonTouched = buttonTouched.getAllDevices
  
  //MARK: Lifecycle functions
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == "deviceOperationsList" {
      let listViewController = segue.destinationViewController as! DeviceOperationsListViewController
      
      switch self.sendingButton {
      case .getAllCapabilities:
        listViewController.dataSource = SupportedCapabilitiesDataSource()
        listViewController.titleText = "All Capabilities"
      case .getAllDevices:
        listViewController.dataSource = SupportedDevicesDataSource()
        listViewController.titleText = "All Devices"
      }
    } else if segue.identifier == "pickerSegue" {
      self.pickerVC = segue.destinationViewController as? PickerViewController
      pickerVC!.delegate = self
    }
  }
  
  //MARK: Capability Action Functions
  func selectedCapability(name: String) {
    /*
     hasDeviceWithCapability checks if the user has a registered device with the capability you pass it.
     In this case, the function is called as a delegate from the PickerViewController file
    */
    neuraSDK.hasDeviceWithCapability(name, withHandler: { (responseData, error) in
      guard let response = responseData["status"] as? String else { return }
      var alertController: UIAlertController
      if response == "NO" {
        alertController = UIAlertController(title: "No device with \(name) capability", message: nil, preferredStyle: .Alert)
      } else {
        alertController = UIAlertController(title: "There is a device with \(name) capability", message: nil, preferredStyle: .Alert)
      }
      let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
      alertController.addAction(okAction)
      self.presentViewController(alertController, animated: true, completion: nil)
    })
  }
  
  //MARK: Add Device Functions
  /*
   addDeviceWithCapability allows you to add a device with an optional specified capability
   or name. If none is specified, Neura will default to the entire device list
 */
  func addDeviceAll() {
    //No device name or capability specified
    neuraSDK.addDeviceWithCapability("", deviceName: "") { (response, error) in
      if error != nil {
        self.errorAddingDevice()
      }
    }
  }
  
  func addDeviceCapability() {
    /*
     For this example, we use stepCount as the capability, but in your app you can
     replace this param with whatever ability you want. Take a look at the list in
     "Get all capabilities" to see all of your options
     */
    neuraSDK.addDeviceWithCapability("stepCount", deviceName: "") { (response, error) in
      if error != nil {
        self.errorAddingDevice()
      }
    }
  }
  
  func addDeviceName() {
    /*
     Here we specify the deviceName and not the deviceCapability. Take a look at the
    "Get all devices list" for a full list of devices
     */
    neuraSDK.addDeviceWithCapability("", deviceName: "Fitbit Charge") { (response, error) in
      if error != nil {
        self.errorAddingDevice()
      }
    }
  }
  
  func errorAddingDevice() {
      let alertController = UIAlertController(title: "Error", message: nil, preferredStyle: .Alert)
      let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
      alertController.addAction(okAction)
      self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  //MARK: IBAction Functions
  @IBAction func backButtonTouched(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func getAllCapabilities(sender: AnyObject) {
    self.sendingButton = buttonTouched.getAllCapabilities
    self.performSegueWithIdentifier("deviceOperationsList", sender: self)
  }
  
  @IBAction func checkUsersCapabilities(sender: AnyObject) {
    pickerVC?.show()
  }
  
  @IBAction func getAllDevicesTouched(sender: AnyObject) {
    self.sendingButton = buttonTouched.getAllDevices
    self.performSegueWithIdentifier("deviceOperationsList", sender: self)
  }
  
  @IBAction func addADeviceTouched(sender: AnyObject) {
    let addDeviceActionSheet = UIAlertController(title: "Pick an option", message: nil, preferredStyle: .ActionSheet)
    let byCapability = UIAlertAction(title: "Add by capability", style: .Default, handler: {action in self.addDeviceCapability()})
    let byName = UIAlertAction(title: "Add by device name", style: .Default, handler: {action in self.addDeviceName()})
    let all = UIAlertAction(title: "Show all", style: .Default, handler: {action in self.addDeviceAll()})
    let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    
    addDeviceActionSheet.addAction(all)
    addDeviceActionSheet.addAction(byCapability)
    addDeviceActionSheet.addAction(byName)
    addDeviceActionSheet.addAction(cancel)
    
    self.presentViewController(addDeviceActionSheet, animated: true, completion: nil)
  }
}
