//
//  EndedTimerTableCell.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/20/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class EndedTimerTableCell: UITableViewCell {

    @IBOutlet weak var timerTitle: UILabel!
    
    @IBOutlet weak var timerLastAlarmTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(timer: EndedTimer){
        self.timerTitle.text = timer.title
        self.timerLastAlarmTime.text = self.formatDate(date: timer.last_alarm_time, type: dateType.date_and_time.rawValue)
    }
    
}
