//
//  GeronimoTimerFunctions.swift
//  Geronimo
//
//  Created by Serg Liamthev on 7/16/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import Foundation

extension GeronimoTimer{
    
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
    
    func calculate_timeToNextAlarm(timer: GeronimoTimer) -> TimeInterval{
        let current_date = Date()
        switch timer.type{
        case TimerData.TimerType.down.rawValue:
            let isStarted = timer.beginDate < current_date || timer.isNow
            let isPaused = isStarted && !timer.isEnabled
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
                    let alarm_count = Double(timer.failCount + timer.succesCount)
                    let difference = timer.beginDate.timeIntervalSince(current_date)
                    let alarms_time = timer.period * alarm_count
                    // Case when timer is old
                    if(alarm_count != 0){
                        return difference - alarms_time
                    } else {
                        // Case when timer just begins
                        return timer.period - difference
                    }
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
            let isPaused = isStarted && !timer.isEnabled
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
