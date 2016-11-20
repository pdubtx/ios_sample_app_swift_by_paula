//
//  SupportedDevicesDataSource.swift
//  Push Notifications Test
//
//  Created by Beau Harper on 10/10/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import Foundation
import UIKit
import NeuraSDK

class SupportedDevicesDataSource: NSObject, UITableViewDataSource, DataSourceProtocol {
  //MARK: Properties
  let neuraSDK = NeuraSDK.sharedInstance()
  var list = [String]()
  var status = [Bool]()
  
  internal func reloadData(_ callback: @escaping () -> ()) {
    self.list = []
    //Returns a list of all devices that Neura supports
    neuraSDK?.getSupportedDevicesList(handler: { (responseData, error) -> Void in
      guard let data = responseData as? [String: NSObject] else { return }
      guard let devices = data["devices"] as? [[String: NSObject]] else { return }
      for device in devices {
        let name = device["name"] as! String
        self.list.append(name)
      }
      callback()
    })
  }
  
  //MARK: Table View Functions
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeviceOperationsTableViewCell
    cell.name.text = list[(indexPath as IndexPath).row]
    return cell
  }
}
