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
    
    var isSwitchEnabled: ((_ isSelected: Bool) -> Void)?
    
    var didChangeTimer: ((Timer?) -> Void)?
    
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(timer: Timer){
        // TODO: update timer icon depending on it status
        self.timer = timer
        timerIcon.image = updateTimerImage()
        self.backgroundColor = updateBackground(isEnabled: isTimerActive(timer: timer))
        timerNextAlarm.text = self.formatIntervalWithSeconds(duration: timer.timeToNextAlarm)
        timerTitle.text = timer.name
        timerStatus.text = timer.timerDescription
        isTimerEnabled.isOn = isTimerActive(timer: timer)
    }
    
    @IBAction func timerStateChanged(_ sender: UISwitch) {
        self.backgroundColor = updateBackground(isEnabled: sender.isOn)
        isSwitchEnabled?(sender.isOn)
        self.timer?.isNow = sender.isOn
        didChangeTimer?(self.timer)
        timerIcon.image = updateTimerImage()
    }
    
    func updateBackground(isEnabled: Bool) -> UIColor{
        if (isEnabled){
            return UIColor.white
        } else {
            return UIColor.groupTableViewBackground
        }
    }
    
    func updateTimerImage() -> UIImage{
        if let timer = self.timer{
            switch(timer.type){
            case TimerData.TimerType.down.rawValue:
                switch (timer.isNow){
                case true:
                    if(timer.beginDate < Date()){
                        return UIImage(named: "timer_active")!
                    }else{
                        return UIImage(named: "timer_not_started")!
                    }
                case false:
                    if(timer.beginDate < Date()){
                        return UIImage(named: "timer_paused")!
                    }else{
                        return UIImage(named: "timer_not_started")!
                    }
                }
            case TimerData.TimerType.up.rawValue:
                if(timer.isNow){
                    return UIImage(named: "timer_up_active")!
                } else{
                    return UIImage(named: "timer_up_not_active")!
                }
            default:
                return UIImage(named: "placeholder")!
            }
        }
        return UIImage(named: "placeholder")!
    }
    
    func isTimerActive(timer: Timer) -> Bool{
        if(timer.isNow || timer.beginDate > Date()){
            return true
        } else {
            return false
        }
    }
    
}
