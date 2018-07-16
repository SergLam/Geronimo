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
    
    var didChangeTimer: ((GeronimoTimer?) -> Void)?
    
    var timer: GeronimoTimer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(timer: GeronimoTimer){
        // TODO: update timer icon depending on it status
        self.timer = timer
        timerIcon.image = updateTimerImage()
        self.backgroundColor = updateBackground(isEnabled: timer.isEnabled)
        timerNextAlarm.text = self.formatIntervalWithSeconds(duration: timer.timeToNextAlarm)
        timerTitle.text = timer.name
        timerStatus.text = timer.timerDescription
        isTimerEnabled.isOn = timer.isEnabled
    }
    
    @IBAction func timerStateChanged(_ sender: UISwitch) {
        self.backgroundColor = updateBackground(isEnabled: sender.isOn)
        isSwitchEnabled?(sender.isOn)
        self.timer?.isEnabled = sender.isOn
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
                switch (timer.isEnabled){
                case true:
                    if(timer.beginDate < Date() || timer.isNow){
                        return UIImage(named: "timer_active")!
                    }else{
                        return UIImage(named: "timer_not_started")!
                    }
                case false:
                    if(timer.beginDate < Date() || timer.isNow){
                        return UIImage(named: "timer_paused")!
                    }else{
                        return UIImage(named: "timer_not_started")!
                    }
                }
            case TimerData.TimerType.up.rawValue:
                if(timer.isEnabled){
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
    
}
