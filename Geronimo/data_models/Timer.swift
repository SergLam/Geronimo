//
//  Timer.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/22/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class Timer: NSObject {
    var id: Int = -1
    var isNew: Bool = true
    
    var name: String = ""
    var timerDescription: String = ""
    var type: String = TimerData.TimerType.down.rawValue
    var period: TimeInterval = 3600 // 1 hour
    var timeToNextAlarm: TimeInterval = 3600
    
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
    var isOnlyWorked = false
    var beginWorkTime: Date = TimerData().currentDate
    var endWorkTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: TimerData().currentDate)!
    // Statistic data
    var succesCount = 0
    var failCount = 0
    // Notification managing data
    var last_alarm_time: Date?
    var lastNotificationID: String?
    
    convenience init(timer_realm: TimerRealm) {
        self.init()
        self.id = timer_realm.id
        self.isNew = timer_realm.isNew
        self.name = timer_realm.name
        self.timerDescription = timer_realm.timerDescription
        self.type = timer_realm.type
        self.period = timer_realm.period
        self.timeToNextAlarm = calculate_timeToNextAlarmFromDB(timer: timer_realm)
        self.isNow = timer_realm.isNow
        self.beginDate = timer_realm.beginDate
        self.beginTime = timer_realm.beginTime
        self.isInfinetily = timer_realm.isInfinetily
        self.repeats = timer_realm.repeats
        self.isNever = timer_realm.isNever
        self.endDate = timer_realm.endDate
        self.endTime = timer_realm.endTime
        self.isOnlyWorked = timer_realm.isOnlyWorked
        self.beginWorkTime = timer_realm.beginWorkTime
        self.endWorkTime = timer_realm.endWorkTime
        self.succesCount = timer_realm.succesCount
        self.failCount = timer_realm.failCount
    }
    
    func calculate_timeToNextAlarmFromDB(timer: TimerRealm) -> TimeInterval{
        let current_date = Date()
        let isStarted = (timer.beginDate < current_date) && (timer.timeToNextAlarm < timer.period)
        if(isStarted){
            return timer.timeToNextAlarm
        } else {
            return timer.period
        }
    }
    
    func calculate_timeToNextAlarm(timer: Timer) -> TimeInterval{
        let current_date = Date()
        let isStarted = (timer.beginDate < current_date) && (timer.timeToNextAlarm < timer.period)
        if(isStarted){
            return timer.timeToNextAlarm
        } else {
            return timer.period
        }
    }
    
}
