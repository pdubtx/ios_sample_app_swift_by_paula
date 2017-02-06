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
  let neuraSDK = NeuraSDK.shared
  var permissionsArray: [NPermission] = []
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
    neuraSDK.getAppPermissionsList() { result in
        if result.error != nil {
            print ("Error with permissions list: \(result.error?.description())")
            return
        }
        self.permissionsArray = result.permissions
        self.permissionsTable.reloadData()
    }
  }
  
  //MARK: Table View Functions
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return permissionsArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = permissionsTable.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
    let permissionObject = permissionsArray[(indexPath as IndexPath).row]
    cell.textLabel?.text = permissionObject.name
    return cell
  }
  
  //MARK: IBAction Functions
  @IBAction func backButtonPressed(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
}
