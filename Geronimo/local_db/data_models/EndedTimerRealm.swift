//
//  EndedTimerRealm.swift
//  Geronimo
//
//  Created by Serg Liamthev on 5/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import RealmSwift

class EndedTimerRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var date_time: Date = TimerData().currentDate
    
    convenience init(ended: EndedTimer) {
        self.init()
        self.id = incrementID()
        self.title = ended.title
        self.date_time = ended.date_time
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func incrementID() -> Int {
        let timers = Array(DBManager.sharedInstance.getEndedTimers())
        if timers.count > 0{
            let max_id = timers.map{$0.id}.max()!
            return max_id + 1
        } else {
            return 0
        }
    }
}
