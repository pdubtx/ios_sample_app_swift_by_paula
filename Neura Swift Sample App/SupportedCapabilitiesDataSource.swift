//
//  SupportedCapabilitiesDataSource.swift
//  Push Notifications Test
//
//  Created by Beau Harper on 10/10/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import Foundation
import UIKit
import NeuraSDK

class SupportedCapabilitiesDataSource: NSObject, UITableViewDataSource, DataSourceProtocol {
  
  //MARK: Properties
  let neuraSDK = NeuraSDK.sharedInstance()
  var list = [String]()

  func reloadData(callback: FetchCallback) {
    self.list = []
    //Returns a list of all capabilities that Neura supports
    neuraSDK.getSupportedCapabilitiesListWithHandler({responseData, error in
      guard let data = responseData as? [String: NSObject] else { return }
      guard let items = data["items"] as? [[String: NSObject]] else { return }
      for item in items {
        let name = item["name"] as! String
        self.list.append(name)
      }
      callback()
    })
  }
  
  //MARK: Table View Functions
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DeviceOperationsTableViewCell
    cell.name.text = list[(indexPath as NSIndexPath).row]
    return cell
  }
}
