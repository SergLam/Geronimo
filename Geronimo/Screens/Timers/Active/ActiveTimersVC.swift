//
//  ActiveTimersVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/20/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import Foundation
import UIKit
import BGTableViewRowActionWithImage

class ActiveTimersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static let sharedInstance = ActiveTimersVC()
    
    @IBOutlet weak var activeTimersTable: UITableView!
    
    var activeTimers: [Timer] = []
    
    let cellName = "ActiveTimerTableCell"
    
    var timerForUIUpdate = Foundation.Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activeTimers.removeAll()
        let db_result = DBManager.sharedInstance.getTimers()
        for timer in db_result{
            activeTimers.append(Timer.init(timer_realm: timer))
        }
        activeTimersTable.reloadData()
        // Configure timer for table update
        timerForUIUpdate.invalidate()
        timerForUIUpdate = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimersNextAlarmTime)), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerForUIUpdate.invalidate()
        // Write active timers to Realm
        updateLocalDBTimers()
    }
    
    func configureTable(){
        activeTimersTable.register(UINib(nibName: cellName, bundle: Bundle.main), forCellReuseIdentifier: cellName)
        activeTimersTable.delegate = self
        activeTimersTable.dataSource = self
        activeTimersTable.rowHeight = 100.0
    }
    
    @objc func updateTimersNextAlarmTime(){
        for index in activeTimers.indices {
            if(activeTimers[index].isNow){
                activeTimers[index].timeToNextAlarm = activeTimers[index].timeToNextAlarm - 1
                let cell = activeTimersTable.cellForRow(at: IndexPath.init(row: index, section: 0)) as! ActiveTimerTableCell
                cell.updateCell(timer: activeTimers[index])
            }
        }
    }
    
    func updateLocalDBTimers(){
        for timer in activeTimers{
            let realm_timer = TimerRealm.init(timer: timer)
            DBManager.sharedInstance.addTimer(object: realm_timer)
        }
    }
    
    // MARK: Table View methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeTimers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activeTimersTable.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! ActiveTimerTableCell
        cell.isSwitchEnabled = { [unowned self] isSelected in
            self.activeTimers[indexPath.row].isNow = isSelected
        }
        cell.updateCell(timer: activeTimers[indexPath.row])
        
        cell.didChangeTimer = { [unowned self] timer in
            if let timer = timer {
                self.activeTimers[indexPath.row] = timer
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = EditTimerVC()
        editVC.setTimer(timer: activeTimers[indexPath.row])
        self.present(editVC, animated: true, completion: nil)
    }
    
    // MARK: Add actions to table
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // Call edit action
            self.activeTimers.remove(at: indexPath.row)
            self.activeTimersTable.deleteRows(at: [indexPath], with: .fade)
            // Reset state
            success(true)
        })
        deleteAction.image = UIImage(named: "check_mark")
        deleteAction.backgroundColor = .red
        
        let statistisAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // Call edit action
            self.present(TimerStatisticVC(), animated: true, completion: nil)
            // Reset state
            success(true)
        })
        statistisAction.image = UIImage(named: "diagram")
        statistisAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [statistisAction, deleteAction])
    }

}
