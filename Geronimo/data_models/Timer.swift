//
//  Timer.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/22/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class Timer {
    
    var name: String = ""
    var description: String = ""
    var type: String = TimerData.TimerType.down.rawValue
    var period: DateComponents = TimerData().currentTime
    
    // Up Timer proporties (Down - Begin block)
    var isNow: Bool = false
    var beginDate: DateComponents = TimerData().currentDate
    var beginTime: DateComponents = TimerData().currentTime
    // Down Timer proporties
    var isInfinetily: Bool = false
    var repeats: Int = 0
    // End block
    var isNever: Bool = false
    var endDate: DateComponents = TimerData().currentDate
    var endTime: DateComponents = TimerData().currentTime
    // Worked time
    var isOnlyWorked = true
    var beginWorkTime: DateComponents = TimerData().currentTime
    var endWorkTime: DateComponents = Calendar.current.dateComponents([ .hour, .minute], from: Date().addingTimeInterval(5.0 * 60.0))
    
    init(){
      
    }
}