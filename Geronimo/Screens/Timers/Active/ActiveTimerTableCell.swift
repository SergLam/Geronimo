//
//  EventTableViewCell.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class ActiveTimerTableCell: UITableViewCell {

    @IBOutlet weak var timerIcon: UIImageView!
    
    @IBOutlet weak var timerNextAlarm: UILabel!
    
    @IBOutlet weak var timerTitle: UILabel!
    
    @IBOutlet weak var timerStatus: UILabel!
    
    @IBOutlet weak var isTimerEnabled: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(timer: Timer){
        // TODO: update timer icon depending on it status
        self.backgroundColor = updateBackground(isEnabled: isTimerActive(timer: timer))
        timerNextAlarm.text = self.formatInterval(duration: timer.timeToNextAlarm)
        timerTitle.text = timer.name
        timerStatus.text = timer.timerDescription
        isTimerEnabled.isOn = isTimerActive(timer: timer)
    }
    
    @IBAction func timerStateChanged(_ sender: UISwitch) {
        self.backgroundColor = updateBackground(isEnabled: sender.isOn)
    }
    
    func updateBackground(isEnabled: Bool) -> UIColor{
        if (isEnabled){
            return UIColor.white
        } else {
            return UIColor.groupTableViewBackground
        }
    }
    
    func isTimerActive(timer: Timer) -> Bool{
        if(timer.isNow || timer.beginDate > Date()){
            return true
        } else {
            return false
        }
    }
    
}
