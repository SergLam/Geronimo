//
//  TimerRealm.swift
//  Geronimo
//
//  Created by Serg Liamthev on 4/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import RealmSwift

class TimerRealm: Object {
    @objc dynamic var id: Int = 0
    
    @objc dynamic var isNew: Bool = true
    @objc dynamic var name: String = ""
    @objc dynamic var timerDescription: String = ""
    @objc dynamic var type: String = TimerData.TimerType.down.rawValue
    @objc dynamic var period: TimeInterval = 3600 // 1 hour
    @objc dynamic var timeToNextAlarm: TimeInterval = 3600
    
    // Up Timer proporties (Down - Begin block)
    @objc dynamic var isNow: Bool = true
    @objc dynamic var beginDate: Date = TimerData().currentDate
    @objc dynamic var beginTime: Date = TimerData().currentDate
    // Down Timer proporties
    @objc dynamic var isInfinetily: Bool = true
    @objc dynamic var repeats: Int = 1
    // End block
    @objc dynamic var isNever: Bool = true
    @objc dynamic var endDate: Date = TimerData().currentDate
    @objc dynamic var endTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: TimerData().currentDate)!
    // Worked time
    @objc dynamic var isOnlyWorked = true
    @objc dynamic var beginWorkTime: Date = TimerData().currentDate
    @objc dynamic var endWorkTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: TimerData().currentDate)!
    // Statistic data
    @objc dynamic var succesCount = 0
    @objc dynamic var failCount = 0
    
    convenience init(timer: Timer) {
        self.init()
        updateTimer(timer: timer)
    }
    
    func updateTimer(timer: Timer){
        if(timer.isNew){
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
        self.isNow = timer.isNow
        self.beginDate = timer.beginDate
        self.beginTime = timer.beginTime
        self.isInfinetily = timer.isInfinetily
        self.repeats = timer.repeats
        self.isNever = timer.isNever
        self.endDate = timer.endDate
        self.endTime = timer.endTime
        self.isOnlyWorked = timer.isOnlyWorked
        self.beginWorkTime = timer.beginWorkTime
        self.endWorkTime = timer.endWorkTime
        self.succesCount = timer.succesCount
        self.failCount = timer.failCount
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func incrementID() -> Int {
        let timers = Array(DBManager.sharedInstance.getTimers())
        if timers.count > 0{
            let max_id = timers.map{$0.id}.max()!
            return max_id + 1
        } else {
           return 0
        }
    }
}
