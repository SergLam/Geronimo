//
//  TimerData.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/22/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

struct TimerData {
    
    var currentTime: DateComponents = Calendar.current.dateComponents([ .hour, .minute], from: Date())
    var period: DateComponents = Calendar.current.dateComponents([ .hour, .minute], from: Date())
    var currentDate: DateComponents = Calendar.current.dateComponents([ .day, .month, .year], from: Date())
    
    enum TimerType: String {
        case up = "Up"
        case down = "Down"
    }
    
    init() {
        self.period.hour = 4
        self.period.minute = 30
        self.period.second = 0
    }
    
}
