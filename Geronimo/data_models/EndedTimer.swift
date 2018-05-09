//
//  EndedTimer.swift
//  Geronimo
//
//  Created by Serg Liamthev on 4/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import RealmSwift

class EndedTimer: Object {
    @objc dynamic var ID = 0
    @objc dynamic var title: String = ""
    @objc dynamic var date_time: Date = TimerData().currentDate
    
    override static func primaryKey() -> String? {
        return "ID"
    }
}
