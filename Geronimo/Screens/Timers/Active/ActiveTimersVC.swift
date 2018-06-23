//
//  ActiveTimersVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/20/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class ActiveTimersVC: UIViewController {
    
    var activeTimersTable = ActiveTimersTable()
    
    var activeTimers: [Timer] = []
    
    var timerForUIUpdate = Foundation.Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeTimers.removeAll()
        let db_result = DBManager.sharedInstance.getTimers()
        setActiveTimers(db_result: db_result)
        self.activeTimersTable.activeTimers = self.activeTimers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTableLayout()
        
        let db_result = DBManager.sharedInstance.getTimers()
        if(activeTimers.count != db_result.count){
            activeTimers.removeAll()
            setActiveTimers(db_result: db_result)
            self.activeTimersTable.activeTimers = self.activeTimers
            activeTimersTable.reloadData()
        }
        
        // Configure timer for table update
        timerForUIUpdate = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimersNextAlarmTime)), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerForUIUpdate.invalidate()
        updateTimersNextAlarmTime()
        // Write active timers to Realm
        updateLocalDBTimers()
    }
    
    func setTableLayout(){
        self.view.addSubview(activeTimersTable)
        activeTimersTable.snp.makeConstraints{(make) -> Void in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func setActiveTimers(db_result: Results<TimerRealm>){
        for timer in db_result{
            activeTimers.append(Timer.init(timer_realm: timer))
        }
    }
    
    @objc func updateTimersNextAlarmTime(){
        for index in activeTimers.indices {
            if(activeTimers[index].isNow){
                switch activeTimers[index].type{
                case TimerData.TimerType.up.rawValue:
                    activeTimers[index].timeToNextAlarm = activeTimers[index].timeToNextAlarm + 1
                    let cell = activeTimersTable.cellForRow(at: IndexPath.init(row: index, section: 0)) as? ActiveTimerTableCell
                    cell?.updateCell(timer: activeTimers[index])
                case TimerData.TimerType.down.rawValue:
                    updateDownTimerAndDB(index: index)
                default:
                    break
                }
            }
        }
    }
    
    func updateDownTimerAndDB(index: Int){
        if(activeTimers[index].timeToNextAlarm != 0){
            activeTimers[index].timeToNextAlarm = activeTimers[index].timeToNextAlarm - 1
            let cell = activeTimersTable.cellForRow(at: IndexPath.init(row: index, section: 0)) as? ActiveTimerTableCell
            cell?.updateCell(timer: activeTimers[index])
        } else {
            // Send notification anyway
            
            if let notificationID = activeTimers[index].lastNotificationID{
                activeTimers[index].last_alarm_time = Date()
                NotificationsManager.sharedInstance.sendNotification(timerTitle: activeTimers[index].name, timerDescription: activeTimers[index].description, timerNotificationID: notificationID)
            }else{
                activeTimers[index].lastNotificationID = NotificationsManager.sharedInstance.randomString()
                activeTimers[index].last_alarm_time = Date()
                NotificationsManager.sharedInstance.sendNotification(timerTitle: activeTimers[index].name, timerDescription: activeTimers[index].description, timerNotificationID: activeTimers[index].lastNotificationID!)
            }
            if(check_timer_end(timer: activeTimers[index])){
                // delete cell form active timers table
                activeTimers.remove(at: index)
                activeTimersTable.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
                // TODO: add to local db Ended timer + delete active timer from DB
                DBManager.sharedInstance.deleteTimer(object: TimerRealm.init(timer: activeTimers[index]))
                DBManager.sharedInstance.addEndedTimer(object: EndedTimerRealm.init(ended: EndedTimer.init(timer: activeTimers[index])))
            } else{
                // update timer time
                activeTimers[index].timeToNextAlarm = activeTimers[index].period
                // update local DB values
                DBManager.sharedInstance.addTimer(object: TimerRealm.init(timer: activeTimers[index]))
            }
        }
    }
    
    func updateLocalDBTimers(){
        for timer in activeTimers{
            let realm_timer = TimerRealm.init(timer: timer)
            DBManager.sharedInstance.addTimer(object: realm_timer)
        }
    }
    
    func check_timer_end(timer: Timer) -> Bool{
        switch timer.type {
        case TimerData.TimerType.down.rawValue:
            let repeats: Bool = timer.repeats >= timer.succesCount + timer.failCount
            if(timer.endDate > Date() && repeats){
                return true
            } else{
                return false
            }
        case TimerData.TimerType.up.rawValue:
            return false
        default:
            return false
        }
    }
    
}
