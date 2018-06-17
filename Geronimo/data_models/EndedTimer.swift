//
//  EndedTimer.swift
//  Geronimo
//
//  Created by Serg Liamthev on 4/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class EndedTimer: NSObject {
    var title: String = ""
    var last_alarm_time: Date = TimerData().currentDate
    // Statistic data
    var succesCount = 0
    var failCount = 0
}
