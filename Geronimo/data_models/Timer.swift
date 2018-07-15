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
    // is Timer enabled by user
    var isEnabled = true
    
    // Up Timer proporties (Down - Begin block)
    var isNow: Bool = true
    // Date & time inside one field
    var beginDate: Date = Calendar.current.date(byAdding: .minute, value: 5, to: TimerData().currentDate)!
    // Down Timer proporties
    var isInfinetily: Bool = true
    var repeats: Int = 1
    // End block
    var isNever: Bool = true
    // Date & time inside one field
    var endDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: TimerData().currentDate)!
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
        
        self.isEnabled = timer_realm.isEnabled
        
        self.isNow = timer_realm.isNow
        self.beginDate = timer_realm.beginDate
        
        self.isInfinetily = timer_realm.isInfinetily
        self.repeats = timer_realm.repeats
        self.isNever = timer_realm.isNever
        self.endDate = timer_realm.endDate
        
        self.isOnlyWorked = timer_realm.isOnlyWorked
        self.beginWorkTime = timer_realm.beginWorkTime
        self.endWorkTime = timer_realm.endWorkTime
        self.succesCount = timer_realm.succesCount
        self.failCount = timer_realm.failCount
        self.last_alarm_time = timer_realm.last_alarm_time
        self.lastNotificationID = timer_realm.lastNotificationID
    }
    
    func calculate_timeToNextAlarmFromDB(timer: TimerRealm) -> TimeInterval{
        let current_date = Date()
        switch timer.type{
        case TimerData.TimerType.down.rawValue:
            let isStarted = timer.beginDate < current_date && timer.endDate > current_date
            let isPaused = isStarted && !timer.isNow
            switch isStarted{
            case true:
                switch isPaused{
                case true:
                    // timeToNextAlarm = (Date() - beginDate) - period*(fail_count + success_count)
                    let difference = timer.beginDate.timeIntervalSince(current_date)
                    let alarms_time = timer.period * Double(timer.failCount + timer.succesCount)
                    return difference - alarms_time
                case false:
                    // timeToNextAlarm = (Date() - beginDate) - period*(fail_count + success_count)
                    let difference = timer.beginDate.timeIntervalSince(current_date)
                    let alarms_time = timer.period * Double(timer.failCount + timer.succesCount)
                    return difference - alarms_time
                }
            case false:
                switch isPaused{
                case true:
                    return timer.period
                case false:
                    return timer.period
                }
            }
        case TimerData.TimerType.up.rawValue:
            let isStarted = current_date > timer.beginDate
            let isPaused = isStarted && !timer.isNow
            switch isStarted{
            case true:
                switch isPaused{
                case true:
                    return timer.timeToNextAlarm
                case false:
                    return current_date.timeIntervalSince(timer.beginDate)
                }
            case false:
                switch isPaused{
                case true:
                    return 0
                case false:
                    return 0
                }
            }
        default:
            return 0
        }
    }
    
    func calculate_timeToNextAlarm(timer: Timer) -> TimeInterval{
        let current_date = Date()
        switch timer.type{
        case TimerData.TimerType.down.rawValue:
            let isStarted = timer.beginDate < current_date && timer.endDate > current_date
            let isPaused = isStarted && !timer.isNow
            switch isStarted{
            case true:
                switch isPaused{
                case true:
                    // timeToNextAlarm = (Date() - beginDate) - period*(fail_count + success_count)
                    let difference = timer.beginDate.timeIntervalSince(current_date)
                    let alarms_time = timer.period * Double(timer.failCount + timer.succesCount)
                    return difference - alarms_time
                    
                case false:
                    // timeToNextAlarm = (Date() - beginDate) - period*(fail_count + success_count)
                    let difference = timer.beginDate.timeIntervalSince(current_date)
                    let alarms_time = timer.period * Double(timer.failCount + timer.succesCount)
                    return difference - alarms_time
                }
            case false:
                switch isPaused{
                case true:
                    return timer.period
                case false:
                    return timer.period
                }
            }
        case TimerData.TimerType.up.rawValue:
            let isStarted = current_date > timer.beginDate
            let isPaused = isStarted && !timer.isNow
            switch isStarted{
            case true:
                switch isPaused{
                case true:
                    return timer.timeToNextAlarm
                case false:
                    return current_date.timeIntervalSince(timer.beginDate)
                }
            case false:
                switch isPaused{
                case true:
                    return 0
                case false:
                    return 0
                }
            }
        default:
            return 0
        }
    }
    
    func calculateLastAlarmTime(timer: Timer) -> Date?{
        switch timer.type {
        case TimerData.TimerType.up.rawValue:
            return nil
        case TimerData.TimerType.down.rawValue:
            var lastAlarmTime = Date()
            lastAlarmTime = lastAlarmTime.addingTimeInterval(-calculate_timeToNextAlarm(timer: timer))
            return lastAlarmTime
        default:
            return nil
        }
    }
    
    func check_timer_end() -> Bool{
        switch self.type {
        case TimerData.TimerType.down.rawValue:
            if(self.isNever){
                return false
            }
            if(self.endDate < Date()){
                return true
            } else{
                return false
            }
        case TimerData.TimerType.up.rawValue:
            return false
        default:
            return false
        }
    }
    
}
