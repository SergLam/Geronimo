//
//  Timer.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/22/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import RealmSwift

class Timer: NSObject {
    var ID = 0
    var isNew: Bool = true

    var name: String = ""
    var timerDescription: String = ""
    var type: String = TimerData.TimerType.down.rawValue
    var period: TimeInterval = 3600 // 1 hour
    
    // Up Timer proporties (Down - Begin block)
    var isNow: Bool = true
    var beginDate: Date = TimerData().currentDate
    var beginTime: Date = TimerData().currentDate
    // Down Timer proporties
    var isInfinetily: Bool = true
    var repeats: Int = 1
    // End block
    var isNever: Bool = true
    var endDate: Date = TimerData().currentDate
    var endTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: TimerData().currentDate)!
    // Worked time
    var isOnlyWorked = true
    var beginWorkTime: Date = TimerData().currentDate
    var endWorkTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: TimerData().currentDate)!
    // Statistic data
    var succesCount = 0
    var failCount = 0
    
}
