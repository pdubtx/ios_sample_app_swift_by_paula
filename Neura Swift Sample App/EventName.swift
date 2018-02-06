//
//  EventName.swift
//  Neura Swift Sample App
//
//  Created by Neura on 05/02/2018.
//  Copyright © 2018 beauNeura. All rights reserved.
//

import Foundation

enum EventName : String {
    
    case eventArrivedHome       = "userArrivedHome"
    case eventLeftHome          = "userLeftHome"
    
    case eventArrivedToWork     = "userArrivedToWork"
    case eventLeftWork          = "userLeftWork"
    
    case eventStartedDriving    = "userStartedDriving"
    case eventFinishedDriving   = "userFinishedDriving"
    
    case eventStartedRunning    = "userStartedRunning"
    case eventFinishedRunning   = "userFinishedRunning"
    
    case eventStartedWalking    = "userStartedWalking"
    case eventFinishedWalking   = "userFinishedWalking"
    
    case eventStartedSleeping   = "userStartedSleeping"
    case eventWokeUp            = "userWokeUp" // Currently not reported on iOS
    case eventGotUp             = "userGotUp"
    case eventArrivedPlace      = "userArrivedPlace"
    case eventLeftPlace         = "userLeftPlace"
}
