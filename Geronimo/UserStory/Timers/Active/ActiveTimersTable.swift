//
//  ActiveTimersTable.swift
//  Geronimo
//
//  Created by Serg Liamthev on 6/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

final class ActiveTimersTable: UITableView, UITableViewDelegate, UITableViewDataSource{
    
    var activeTimers: [GeronimoTimer] = []
    
    let cellName = "ActiveTimerTableCell"
    
    override init(frame: CGRect, style: UITableView.Style) {
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
        return activeTimers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? ActiveTimerTableCell else {
            assertionFailure("Unable to dequeueReusableCell id - \(cellName)")
            return UITableViewCell()
        }
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
        
        let editVC = EditTimerVC(timer: activeTimers[indexPath.row])
        UIApplication.topViewController()?.present(editVC, animated: true, completion: nil)
    }
    
    // MARK: Add actions to table
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: { _, _, success in
            DBManager.sharedInstance.deleteTimerById(timer_id: self.activeTimers[indexPath.row].id)
            self.activeTimers.remove(at: indexPath.row)
            self.deleteRows(at: [indexPath], with: .fade)
            success(true)
        })
        deleteAction.image = UIImage(named: "check_mark")
        deleteAction.backgroundColor = .red
        
        let statistisAction = UIContextualAction(style: .normal, title: "", handler: { _, _, success in
            UIApplication.shared.keyWindow?.rootViewController?.present(TimerStatisticVC(timer: self.activeTimers[indexPath.row]), animated: true, completion: nil)
            success(true)
        })
        statistisAction.image = UIImage(named: "diagram")
        statistisAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [statistisAction, deleteAction])
    }
    
}
