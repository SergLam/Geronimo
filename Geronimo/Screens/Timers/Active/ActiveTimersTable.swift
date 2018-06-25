//
//  ActiveTimersTable.swift
//  Geronimo
//
//  Created by Serg Liamthev on 6/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class ActiveTimersTable: UITableView, UITableViewDelegate, UITableViewDataSource{
    
    var activeTimers: [Timer] = []
    
    let cellName = "ActiveTimerTableCell"
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.register(UINib(nibName: cellName, bundle: Bundle.main), forCellReuseIdentifier: cellName)
        self.delegate = self
        self.dataSource = self
        self.rowHeight = 100.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Table View methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeTimers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! ActiveTimerTableCell
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
        UIApplication.shared.keyWindow?.rootViewController?.present(editVC, animated: true, completion: nil)
//        self.present(editVC, animated: true, completion: nil)
    }
    
    // MARK: Add actions to table
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            DBManager.sharedInstance.deleteTimer(object: TimerRealm.init(timer: self.activeTimers[indexPath.row]))
            self.activeTimers.remove(at: indexPath.row)
            self.deleteRows(at: [indexPath], with: .fade)
            success(true)
        })
        deleteAction.image = UIImage(named: "check_mark")
        deleteAction.backgroundColor = .red
        
        let statistisAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            UIApplication.shared.keyWindow?.rootViewController?.present(TimerStatisticVC.init(timer: self.activeTimers[indexPath.row]), animated: true, completion: nil)
            success(true)
        })
        statistisAction.image = UIImage(named: "diagram")
        statistisAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [statistisAction, deleteAction])
    }
    
    
}
