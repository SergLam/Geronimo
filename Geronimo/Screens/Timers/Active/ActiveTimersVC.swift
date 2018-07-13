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
    
    var timerForUIUpdate = Foundation.Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeTimersTable.activeTimers.removeAll()
        let db_result = DBManager.sharedInstance.getTimers()
        setActiveTimers(db_result: db_result)
        setTableLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocalDBTimers), name: NSNotification.Name(rawValue: NotificationsManager.sharedInstance.updateLocalDBNotificationID), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let db_result = DBManager.sharedInstance.getTimers()
        if(activeTimersTable.activeTimers.count != db_result.count){
            activeTimersTable.activeTimers.removeAll()
            setActiveTimers(db_result: db_result)
            activeTimersTable.reloadData()
        } else{
            updateActiveTimers()
        }
        timerForUIUpdate.invalidate()
        // Configure timer for table update
        timerForUIUpdate = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.incrementTimersNextAlarmTime)), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerForUIUpdate.invalidate()
        updateActiveTimers()
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
    
    func updateActiveTimers(){
        for (index, timer) in activeTimersTable.activeTimers.enumerated(){
            if(timer.check_timer_end()){
                timer.timeToNextAlarm = timer.calculate_timeToNextAlarm(timer: timer)
            } else {
                DBManager.sharedInstance.deleteTimer(object: TimerRealm.init(timer: timer))
                activeTimersTable.activeTimers.remove(at: index)
            }
        }
    }
    
    // MARK: methods for timers
    
    func setActiveTimers(db_result: Results<TimerRealm>){
        for timer_realm in db_result{
            let timer = Timer.init(timer_realm: timer_realm)
            if let _ = timer.lastNotificationID, let time = timer.last_alarm_time{
                if(time > Date()){
                    timer.failCount = timer.failCount + 1
                    timer.lastNotificationID = nil
                    timer.last_alarm_time = nil
                }
            }
            activeTimersTable.activeTimers.append(timer)
        }
    }
    
    @objc func incrementTimersNextAlarmTime(){
        for index in activeTimersTable.activeTimers.indices {
            if(activeTimersTable.activeTimers[index].isNow){
                switch activeTimersTable.activeTimers[index].type{
                case TimerData.TimerType.up.rawValue:
                    activeTimersTable.activeTimers[index].timeToNextAlarm = activeTimersTable.activeTimers[index].timeToNextAlarm + 1
                    let cell = activeTimersTable.cellForRow(at: IndexPath.init(row: index, section: 0)) as? ActiveTimerTableCell
                    cell?.updateCell(timer: activeTimersTable.activeTimers[index])
                case TimerData.TimerType.down.rawValue:
                    updateDownTimerAndDB(index: index)
                default:
                    break
                }
            }
        }
    }
    
    func updateDownTimerAndDB(index: Int){
        let cell = activeTimersTable.cellForRow(at: IndexPath.init(row: index, section: 0)) as? ActiveTimerTableCell
        if(activeTimersTable.activeTimers[index].timeToNextAlarm > 0){
            activeTimersTable.activeTimers[index].timeToNextAlarm = activeTimersTable.activeTimers[index].timeToNextAlarm - 1
            cell?.updateCell(timer: activeTimersTable.activeTimers[index])
        } else {
            // TODO: update active timer somehow if time ends
            if(activeTimersTable.activeTimers[index].check_timer_end()){
                activeTimersTable.activeTimers[index].timeToNextAlarm = activeTimersTable.activeTimers[index].period
                cell?.updateCell(timer: activeTimersTable.activeTimers[index])
            } else{
                DBManager.sharedInstance.deleteTimerById(timer: activeTimersTable.activeTimers[index])
                activeTimersTable.activeTimers.remove(at: index)
            }
        }
    }
    
    @objc func updateLocalDBTimers(){
        updateActiveTimers()
        for timer in activeTimersTable.activeTimers{
            let realm_timer = TimerRealm.init(timer: timer)
            DBManager.sharedInstance.addTimer(object: realm_timer)
        }
    }
    

    
}
