//
//  SubscriptionsListViewController.swift
//  Push Notifications Test
//
//  Created by Beau Harper on 7/13/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import Foundation
import UIKit
import NeuraSDK

class SubscriptionsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
  //MARK: Properties
  let neuraSDK = NeuraSDK.sharedInstance()
    var permissionsArray = [
        "userArrivedHome",
        "userArrivedHomeFromWork",
        "userLeftHome",
        "userArrivedHomeByWalking",
        "userArrivedHomeByRunning",
        "userIsOnTheWayHome",
        "userIsIdleAtHome",
        "userStartedWorkOut",
        "userFinishedRunning",
        "userFinishedWorkOut",
        "userLeftGym",
        "userFinishedWalking",
        "userArrivedToGym",
        "userIsIdleFor2Hours",
        "userStartedWalking",
        "userIsIdleFor1Hour",
        "userStartedRunningFromPlace",
        "userStartedTransitByWalking",
        "userStartedRunning",
        "userFinishedTransitByWalking"
    ]
  var subscriptionsArray: NSArray = []
  let cellReuseIdentifier = "SuscriptionsListViewCell"
  
  //MARK: IBOutlets
  @IBOutlet weak var subscriptionsTableView: UITableView!
  
  //MARK: Lifecycle functions
  override func viewDidLoad() {
    super.viewDidLoad()
    subscriptionsTableView.delegate = self
    subscriptionsTableView.dataSource = self
    reloadAllData()
  }
  
  func  reloadAllData() {
    neuraSDK.getSubscriptions({ (responseData, error) in
      if error == nil {
        let data = responseData as? [String:NSObject]
        let subscriptionsArray = data!["items"] as? [NSObject]
        self.subscriptionsArray = subscriptionsArray!
        self.subscriptionsTableView.reloadData()
      }
    })
  }
  
  //MARK: Table view functions
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return permissionsArray.count
  }
  
  //Create a cell for each table view row
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell:SubscriptionsTableViewCell = self.subscriptionsTableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! SubscriptionsTableViewCell
    cell.subscribeSwitch.addTarget(self, action: #selector(SubscriptionsListViewController.subscribeToEventSwitch(_:)), forControlEvents: UIControlEvents.ValueChanged)
    let permissionString = permissionsArray[(indexPath as NSIndexPath).row]
    cell.subscriptionName.text = permissionString
    if self.subscriptionsArray.count != 0 {
      for subscription in self.subscriptionsArray {
        guard let dictionary = subscription as? NSDictionary else { return cell }
        if dictionary.objectForKey("eventName")?.isEqualToString(permissionString) != false {
          cell.subscribeSwitch.on = true
          break
        }
        else { cell.subscribeSwitch.on = false }
      }
    }else { cell.subscribeSwitch.on = false }
    return cell
  }
  
  func subscribeToEventSwitch(subscribeSwitch: UISwitch) {
    let cell = subscribeSwitch.superview?.superview as! SubscriptionsTableViewCell
    let indexPath = self.subscriptionsTableView.indexPathForCell(cell)
    let eventName = self.permissionsArray[indexPath!.row]
    
    if subscribeSwitch.on {
      //this function checks whether an event subscription is missing data in order to successfully subscribe
      if neuraSDK.isMissingDataForEvent(eventName) == true {
        let alertController = UIAlertController(title: "The place has not been set yet. Create it now?", message: nil, preferredStyle: .Alert)
        let noAction = UIAlertAction(title: "I will wait", style: .Default, handler: {_ in self.subscribeToEvent(eventName)})
        alertController.addAction(noAction)
        let okAction = UIAlertAction(title: "Yes", style: .Default, handler: {_ in self.addMissingDataToEvent(eventName, subscribeSwitch: subscribeSwitch)})
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
      } else {
        subscribeToEvent(eventName)
      }
    } else {
      self.removeSubscriptionWithIdentifier(eventName)
    }
  }
  
  func addMissingDataToEvent(eventName: String, subscribeSwitch: UISwitch){
    //If the user chooses to add the missing data for the event, call this function with the event name
    neuraSDK.getMissingDataForEvent(eventName) { (responseData, error) in
      if error == nil {
        let responseStatus = responseData["status"] as! String
        if responseStatus == "success" {
          self.subscribeToEvent(eventName)
        }
        else{
          subscribeSwitch.on = false
        }
      }
    }
  }
  
  func subscribeToEvent(eventName: String) {
    neuraSDK.subscribeToEvent(eventName, identifier: (eventName), webHookID: nil) { (responseData, error) in
      if error != nil {
        let alertController = UIAlertController(title: "Error", message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
      }
      self.reloadAllData()
    }
  }
  
  func removeSubscriptionWithIdentifier(identifier: String){
    neuraSDK.removeSubscriptionWithIdentifier(identifier) { responseData, error in
      if error != nil {
        let alertController = UIAlertController(title: "Error", message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
      }
      self.reloadAllData()
    }
  }
  
  //MARK: IBActions
  @IBAction func backButtonPressed(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
