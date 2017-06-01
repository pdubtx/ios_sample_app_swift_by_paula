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
    let neuraSDK = NeuraSDK.shared
    // Declare the permissions you'll want to request here. These can be found in the app wizard in the developer console at the bottom of the page.
    // They should correspond to the permissions group that you've declared in the authenticate with permissions function elsewhere (in the main view controller in this case)
    var eventNamesArray = [
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
    var subscriptions = [String: NSubscription]()
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
    
    func reloadAllData() {
        self.subscriptions.removeAll()
        neuraSDK.getSubscriptionsList() { result in
            guard result.success else { return }
            for subscription in result.subscriptions {
                self.subscriptions[subscription.eventName] = subscription
            }
            self.subscriptionsTableView.reloadData()
        }
    }
    
    //MARK: Table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventNamesArray.count
    }
    
    //Create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SubscriptionsTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SubscriptionsTableViewCell
        
        // Add a handler for value changes, if missing.
        if cell.subscribeSwitch.allTargets.count == 0 {
            cell.subscribeSwitch.addTarget(self, action: #selector(SubscriptionsListViewController.subscribeToEventSwitch(_:)), for: UIControlEvents.valueChanged)
        }
        
        // Configure the cell.
        let eventName = self.eventNamesArray[indexPath.item]
        cell.subscriptionName?.text = eventName
        
        if let _ = self.subscriptions[eventName] {
            cell.subscribeSwitch.isOn = true
        } else {
            cell.subscribeSwitch.isOn = false
        }
        
        return cell
    }
    
    func subscribeToEventSwitch(_ subscribeSwitch: UISwitch) {
        let cell = subscribeSwitch.superview?.superview as! SubscriptionsTableViewCell
        let indexPath = self.subscriptionsTableView.indexPath(for: cell)
        let eventName = self.eventNamesArray[(indexPath?.row)!]
        
        if subscribeSwitch.isOn {
            //this function checks whether an event subscription is missing data in order to successfully subscribe
            if neuraSDK.isMissingData(forEvent: eventName) == true {
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
        neuraSDK.getMissingData(forEvent: eventName) { missingDataResult in
            if missingDataResult.error != nil {
                subscribeSwitch.isOn = false
                return
            }
        }
    }

    func subscribeToEvent(_ eventName: String) {
        let webHookId = "myWebHookId" // <== You will need to change this id to the one you defined on the dev site.
        let nSubscription = NSubscription(eventName: eventName, webhookId: webHookId)
        neuraSDK.add(nSubscription)  { result in
            if result.error != nil {
                let alertController = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            self.reloadAllData()
        }
    }

    func removeSubscriptionWithIdentifier(_ identifier: String){
//        let nSubscription = NSubscription.init(eventName: identifier, identifier: "_\(identifier)")
//        neuraSDK.remove(nSubscription) { result in
//            if result.error != nil {
//                let alertController = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//            self.reloadAllData()
//        }
    }
    
    //MARK: IBActions
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
