//
//  TestViewController.swift
//  Push Notifications Test
//
//  Created by Beau Harper on 7/12/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import Foundation
import UIKit
import NeuraSDK

class PermissionsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  //MARK: Properties
  let neuraSDK = NeuraSDK.sharedInstance()
  var permissionsArray: NSArray = []
  @IBOutlet weak var permissionsTable: UITableView!
  
  //MARK: Lifecycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    permissionsTable.delegate = self
    permissionsTable.dataSource = self
    loadPermissions()
  }
  
  func loadPermissions(){
    /*
     Returns a list of all the permissions that an app may request. These may be edited in the
     console at dev.theneura.com
     */
    neuraSDK.getAppPermissionsWithHandler { (responseArray, error) in
      if error == nil{
        self.permissionsArray = responseArray!
        self.permissionsTable.reloadData()
      }
    }
  }
  
  //MARK: Table View Functions
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return permissionsArray.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = permissionsTable.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath)
    let permissionDictionary = permissionsArray[(indexPath as NSIndexPath).row]
    let textString = permissionDictionary["displayName"] as! String
    
    cell.textLabel?.text = textString
    return cell
  }
  
  //MARK: IBAction Functions
  @IBAction func backButtonPressed(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
