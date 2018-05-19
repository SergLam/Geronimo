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
    @objc dynamic var id: Int = Date().hashValue + Int(arc4random_uniform(1000))
    
    var title: String = ""
    var date_time: Date = TimerData().currentDate
    
    convenience init(ended: EndedTimer) {
        self.init()
        self.title = ended.title
        self.date_time = ended.date_time
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
