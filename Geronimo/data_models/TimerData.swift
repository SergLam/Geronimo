//
//  TimerData.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/22/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class TimerData {
    
    var currentTime: DateComponents = Calendar.current.dateComponents([ .hour, .minute], from: Date())
    var period: DateComponents = Calendar.current.dateComponents([ .hour, .minute], from: Date())
    var currentDate: Date = Date()
    
    enum TimerType: String {
        case up = "Up"
        case down = "Down"
    }
    
}
