//
//  TimerData.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/22/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

struct TimerData {
    
    var currentDate: Date = Date()
    
    enum TimerType: String {
        case up = "Up"
        case down = "Down"
    }
    
}
