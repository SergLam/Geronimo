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
    var title: String = ""
    var date_time: Date = TimerData().currentDate
}
