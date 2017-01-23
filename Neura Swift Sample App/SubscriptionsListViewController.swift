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
    // Declare the permissions you'll want to request here. These can be found in the app wizard in the developer console at the bottom of the page.
    // They should correspond to the permissions group that you've declared in the authenticate with permissions function elsewhere (in the main view controller in this case)
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
    var subscriptionsArray = [String]()
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
        neuraSDK?.getSubscriptionsList(callback: { (subscriptionsResult) in
            if subscriptionsResult.error != nil {
                return
            }
            for subscription in subscriptionsResult.subscriptions {
                self.subscriptionsArray.append(subscription.eventName)
            }
            self.subscriptionsTableView.reloadData()
        })
    }
    
    //MARK: Table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return permissionsArray.count
    }
    
    //Create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SubscriptionsTableViewCell = self.subscriptionsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SubscriptionsTableViewCell
        cell.subscribeSwitch.addTarget(self, action: #selector(SubscriptionsListViewController.subscribeToEventSwitch(_:)), for: UIControlEvents.valueChanged)
        
        let permissionString = permissionsArray[(indexPath as IndexPath).row]
        cell.subscriptionName.text = permissionString
        if self.subscriptionsArray.count != 0 {
            for subscription in self.subscriptionsArray {
                
                if (subscription).isEqual(permissionString) != false {
                    cell.subscribeSwitch.isOn = true
                    break
                }
                else { cell.subscribeSwitch.isOn = false }
            }
        }else { cell.subscribeSwitch.isOn = false }
        return cell
    }
    
    func subscribeToEventSwitch(_ subscribeSwitch: UISwitch) {
        let cell = subscribeSwitch.superview?.superview as! SubscriptionsTableViewCell
        let indexPath = self.subscriptionsTableView.indexPath(for: cell)
        //        let permissionDictionary = self.permissionsArray.object(at: indexPath!.row) as! [String: Any]
        //        let eventName = permissionDictionary["name"] as! String?
        let eventName = permissionsArray[(indexPath?.row)!]
        
        if subscribeSwitch.isOn {
            //this function checks whether an event subscription is missing data in order to successfully subscribe
            if neuraSDK?.isMissingData(forEvent: eventName) == true {
                let alertController = UIAlertController(title: "The place has not been set yet. Create it now?", message: nil, preferredStyle: .alert)
                let noAction = UIAlertAction(title: "I will wait", style: .default, handler: {_ in self.subscribeToEvent(eventName)})
                alertController.addAction(noAction)
                let okAction = UIAlertAction(title: "Yes", style: .default, handler: {_ in self.addMissingDataToEvent(eventName, subscribeSwitch: subscribeSwitch)})
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                subscribeToEvent(eventName)
            }
        } else {
            removeSubscriptionWithIdentifier(eventName)
        }
    }
    
    func addMissingDataToEvent(_ eventName: String, subscribeSwitch: UISwitch){
        //If the user chooses to add the missing data for the event, call this function with the event name
        neuraSDK?.getMissingData(forEvent: eventName, withCallback: { (missingDataResult) in
            if missingDataResult.error != nil {
                subscribeSwitch.isOn = false
                return
            }
        })
    }
    
    func subscribeToEvent(_ eventName: String) {
        let nSubscription = NSubscription.init(eventNamed: eventName)
        neuraSDK?.add(nSubscription, callback: { (result) in
            if (result.error != nil){
                let alertController = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            self.reloadAllData()
        })
    }
    
    func removeSubscriptionWithIdentifier(_ identifier: String){
        let nSubscription = NSubscription.init(identifier: identifier)
        neuraSDK?.remove(nSubscription, callback: { (result) in
            if (result.error != nil) {
                let alertController = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            self.reloadAllData()
        })
    }
    
    //MARK: IBActions
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
