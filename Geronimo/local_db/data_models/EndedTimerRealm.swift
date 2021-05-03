//
//  EndedTimerRealm.swift
//  Geronimo
//
//  Created by Serg Liamthev on 5/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import RealmSwift
import UIKit

final class EndedTimerRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var last_alarm_time: Date = TimerData().currentDate
    @objc dynamic var succesCount = 0
    @objc dynamic var failCount = 0
    
    convenience init(ended: EndedTimer) {
        self.init()
        self.id = incrementID()
        self.title = ended.title
        self.last_alarm_time = ended.last_alarm_time
        self.succesCount = ended.succesCount
        self.failCount = ended.failCount
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func incrementID() -> Int {
        let timers = Array(DBManager.sharedInstance.getEndedTimers())
        if !timers.isEmpty {
            let max_id = timers.map{ $0.id }.max() ?? 0
            return max_id + 1
        } else {
            return 0
        }
    }
    
}
