//
//  PickerViewController.swift
//  Push Notifications Test
//
//  Created by Beau Harper on 10/10/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import Foundation
import UIKit
import NeuraSDK

//MARK: Picker Delegate Protocol
protocol PickerDelegate: class {
  func selectedCapability(name: String)
}

class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  //MARK: Properties
  let neuraSDK = NeuraSDK.sharedInstance()
  var pickerData = [String]()
  weak var delegate: PickerDelegate? = nil
  @IBOutlet weak var capabilityPicker: UIPickerView!
  
  //MARK: Lifecycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    capabilityPicker.dataSource = self
    capabilityPicker.delegate = self
    self.getData()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.hide()
  }
  
  func getData() {
    //Gets all of Neura's supported capabilities.
    neuraSDK.getSupportedCapabilitiesListWithHandler({responseData, error in
      var capabilitiesList = [String]()
      guard let data = responseData as? [String: NSObject] else { return }
      guard let items = data["items"] as? [[String: NSObject]] else { return }
      for item in items {
        let name = item["name"] as! String
        capabilitiesList.append(name)
      }
      self.pickerData = capabilitiesList
      self.capabilityPicker.reloadAllComponents()
    })
  }
  
  //MARK: Picker Functions
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count;
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
  }
  
  func show() {
    self.view.superview?.alpha = 1
  }
  
  func hide() {
    self.view.superview?.alpha = 0
  }
  
  //MARK: IBAction Functions
  @IBAction func checkTouched(sender: AnyObject) {
    let name = self.pickerData[self.capabilityPicker.selectedRowInComponent(0)]
    self.delegate?.selectedCapability(name)
    self.hide()
  }
  
  @IBAction func cancelTouched(sender: AnyObject) {
    self.hide()
  }
}
