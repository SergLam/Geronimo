//
//  EndedTimer.swift
//  Geronimo
//
//  Created by Serg Liamthev on 4/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class EndedTimer: NSObject {
    var id: Int = 0
    var title: String = ""
    var last_alarm_time: Date = TimerData().currentDate
    // Statistic data
    var succesCount = 0
    var failCount = 0
    
    convenience init(timer: Timer) {
        self.init()
        self.id = timer.id
        self.title = timer.name
        self.succesCount = timer.succesCount
        self.failCount = timer.failCount
    }
    
    convenience init(ended_timer_realm: EndedTimerRealm){
        self.init()
        self.id = ended_timer_realm.id
        self.title = ended_timer_realm.title
        self.succesCount = ended_timer_realm.succesCount
        self.failCount = ended_timer_realm.failCount
    }
}
