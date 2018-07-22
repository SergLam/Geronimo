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
    
    var timerForUIUpdate: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocalDBTimers), name: NSNotification.Name(rawValue: NotificationsManager.sharedInstance.updateLocalDBNotificationID), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let db_result = DBManager.sharedInstance.getTimers()
        activeTimersTable.activeTimers.removeAll()
        setActiveTimers(db_result: db_result)
        updateActiveTimers()
        // Configure timer for table update
        timerForUIUpdate = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.incrementTimersNextAlarmTime)), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerForUIUpdate?.invalidate()
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
            if(!timer.check_timer_end(timer: timer)){
                timer.timeToNextAlarm = timer.calculate_timeToNextAlarm(timer: timer)
            } else {
                DBManager.sharedInstance.deleteTimerById(timer_id: timer.id)
                activeTimersTable.activeTimers.remove(at: index)
                activeTimersTable.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
            }
        }
        activeTimersTable.reloadData()
    }
    
    // MARK: methods for timers
    
    func setActiveTimers(db_result: Results<TimerRealm>){
        for timer_realm in db_result{
            let timer = GeronimoTimer.init(timer_realm: timer_realm)
            if let _ = timer.lastNotificationID, let time = timer.last_alarm_time{
                if(time > Date()){
                    timer.failCount = timer.failCount + 1
                    timer.lastNotificationID = nil
                    timer.last_alarm_time = nil
                }
            }
            if(!timer.check_timer_end(timer: timer)){
                activeTimersTable.activeTimers.append(timer)
            } else{
                print("Timer finished, not added to active")
            }
        }
    }
    
    @objc func incrementTimersNextAlarmTime(){
        for (index, timer) in activeTimersTable.activeTimers.enumerated() {
            if(timer.isEnabled){
                switch timer.type{
                case TimerData.TimerType.up.rawValue:
                    if(timer.isNow || timer.beginDate < Date()){
                        timer.timeToNextAlarm = timer.timeToNextAlarm + 1
                        let cell = activeTimersTable.cellForRow(at: IndexPath.init(row: index, section: 0)) as? ActiveTimerTableCell
                        cell?.updateCell(timer: timer)
                    }
                case TimerData.TimerType.down.rawValue:
                    updateDownTimer(index: index)
                default:
                    break
                }
            }
        }
    }
    
    func updateDownTimer(index: Int){
        let cell = activeTimersTable.cellForRow(at: IndexPath.init(row: index, section: 0)) as? ActiveTimerTableCell
        let timer = activeTimersTable.activeTimers[index]
        if(timer.timeToNextAlarm > 0){
            timer.timeToNextAlarm = timer.timeToNextAlarm - 1
            cell?.updateCell(timer: timer)
        } else {
            // TODO: update active timer somehow if time ends
            if(timer.check_timer_end(timer: timer)){
                timer.timeToNextAlarm = timer.period
                cell?.updateCell(timer: timer)
            } else{
                DBManager.sharedInstance.deleteTimerById(timer_id: activeTimersTable.activeTimers[index].id)
                activeTimersTable.activeTimers.remove(at: index)
                activeTimersTable.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
            }
        }
    }
    
    @objc func updateLocalDBTimers(){
        for timer in activeTimersTable.activeTimers{
            let realm_timer = TimerRealm.init(timer: timer)
            DBManager.sharedInstance.addTimer(object: realm_timer)
        }
    }
    
    
    
}
