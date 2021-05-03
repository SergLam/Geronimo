//
//  EndedTimersVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/20/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

final class EndedTimersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableEndedTimers: UITableView!
    
    let cellName = "EndedTimerTableCell"
    
    var endedTimers: [EndedTimer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        endedTimers.removeAll()
        let endedRealmTimers = DBManager.sharedInstance.getEndedTimers()
        for timer in endedRealmTimers{
            endedTimers.append(EndedTimer(ended_timer_realm: timer))
        }
    }
    
    func configureTable(){
        tableEndedTimers.register(UINib(nibName: cellName, bundle: Bundle.main), forCellReuseIdentifier: cellName)
        tableEndedTimers.delegate = self
        tableEndedTimers.dataSource = self
        tableEndedTimers.rowHeight = 100.0
    }
    
    // MARK: Add action to cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let removeAction = UIContextualAction(style: .normal, title: "", handler: { _, _, success in
            // Call action
            let endedTimer = self.endedTimers[indexPath.row]
            if let active_timer = DBManager.sharedInstance.getTimerByID(timerID: endedTimer.id){
                // TODO: update active timer - remove last notification time + ID + increment success count
                active_timer.lastNotificationID = nil
                active_timer.last_alarm_time = nil
                active_timer.succesCount += 1
                DBManager.sharedInstance.addTimer(object: active_timer)
            }
            self.endedTimers.remove(at: indexPath.row)
            self.tableEndedTimers.deleteRows(at: [indexPath], with: .fade)

            // Reset state
            success(true)
        })
        removeAction.image = UIImage(named: "check_mark")
        removeAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endedTimers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableEndedTimers.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? EndedTimerTableCell else {
            assertionFailure("Unable to dequeueReusableCell with id - \(cellName)")
            return UITableViewCell()
        }
        return cell
    }

}
