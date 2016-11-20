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
    neuraSDK?.getAppPermissions { (responseArray, error) in
      if error == nil{
        self.permissionsArray = responseArray! as NSArray
        self.permissionsTable.reloadData()
      }
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
    let permissionDictionary = permissionsArray[(indexPath as IndexPath).row] as? [String: Any]
    let textString = (permissionDictionary?["displayName"]!)! as! String
    
    cell.textLabel?.text = textString
    return cell
  }
  
  //MARK: IBAction Functions
  @IBAction func backButtonPressed(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
}
