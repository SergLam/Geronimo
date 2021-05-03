//
//  TimerRealm.swift
//  Geronimo
//
//  Created by Serg Liamthev on 4/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import RealmSwift
import UIKit

final class TimerRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var isNew: Bool = true
    
    @objc dynamic var name: String = ""
    @objc dynamic var timerDescription: String = ""
    @objc dynamic var type: String = TimerData.TimerType.down.rawValue
    @objc dynamic var period: TimeInterval = 3600 // 1 hour
    @objc dynamic var timeToNextAlarm: TimeInterval = 3600
    // is Timer enabled by user
    @objc dynamic var isEnabled = true
    
    // Up Timer proporties (Down - Begin block)
    @objc dynamic var isNow: Bool = true
    // Date & time inside one field
    @objc dynamic var beginDate: Date = TimerData().currentDate
    // Down Timer proporties
    @objc dynamic var isInfinetily: Bool = true
    @objc dynamic var repeats: Int = 1
    // End block
    @objc dynamic var isNever: Bool = true
    // Date & time inside one field
    @objc dynamic var endDate: Date = TimerData().currentDate
    // Worked time
    @objc dynamic var isOnlyWorked = true
    @objc dynamic var beginWorkTime: Date = TimerData().currentDate
    @objc dynamic var endWorkTime: Date = TimerData().currentDate.addingTimeInterval(TimeInterval.hour)
    // Statistic data
    @objc dynamic var succesCount = 0
    @objc dynamic var failCount = 0
    // Notification managing data
    @objc dynamic var last_alarm_time: Date?
    @objc dynamic var lastNotificationID: String?
    
    convenience init(timer: GeronimoTimer) {
        self.init()
        updateTimer(timer: timer)
    }
    
    func updateTimer(timer: GeronimoTimer){
        if timer.id == -1 {
            self.id = incrementID()
        } else {
            self.id = timer.id
        }
        self.isNew = timer.isNew
        self.name = timer.name
        self.timerDescription = timer.timerDescription
        self.type = timer.type
        self.period = timer.period
        self.timeToNextAlarm = timer.timeToNextAlarm
        self.isEnabled = timer.isEnabled
        self.isNow = timer.isNow
        self.beginDate = timer.beginDate
        self.isInfinetily = timer.isInfinetily
        self.repeats = timer.repeats
        self.isNever = timer.isNever
        self.endDate = timer.endDate
        self.isOnlyWorked = timer.isOnlyWorked
        self.beginWorkTime = timer.beginWorkTime
        self.endWorkTime = timer.endWorkTime
        self.succesCount = timer.succesCount
        self.failCount = timer.failCount
        self.last_alarm_time = timer.last_alarm_time
        self.lastNotificationID = timer.lastNotificationID
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func incrementID() -> Int {
        let timers = Array(DBManager.sharedInstance.getTimers())
        if !timers.isEmpty {
            let max_id = timers.map{ $0.id }.max() ?? 0
            return max_id + 1
        } else {
           return 0
        }
    }
}
