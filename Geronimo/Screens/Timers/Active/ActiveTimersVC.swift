//
//  ActiveTimersVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/20/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import BGTableViewRowActionWithImage

class ActiveTimersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activeTimersTable: UITableView!
    
    var activeTimers: [Timer] = []
    
    let cellName = "ActiveTimerTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTable()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activeTimers.removeAll()
        let db_result = DBManager.sharedInstance.getTimers()
        for timer in db_result{
            activeTimers.append(Timer.init(timer_realm: timer))
        }
        activeTimersTable.reloadData()
    }
    
    func configureTable(){
        activeTimersTable.register(UINib(nibName: cellName, bundle: Bundle.main), forCellReuseIdentifier: cellName)
        activeTimersTable.delegate = self
        activeTimersTable.dataSource = self
        activeTimersTable.rowHeight = 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeTimers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activeTimersTable.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! ActiveTimerTableCell
        cell.updateCell(timer: activeTimers[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = EditTimerVC()
        editVC.setTimer(timer: activeTimers[indexPath.row])
        self.present(editVC, animated: true, completion: nil)
    }
    
    // MARK: Add actions to table
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let deleteAction = BGTableViewRowActionWithImage.rowAction(with: .destructive, title: "    ", backgroundColor: UIColor.red, image: UIImage(named: "trash_can"), forCellHeight: 100, handler: { (action, indexpath) in
            self.activeTimers.remove(at: indexPath.row)
            self.activeTimersTable.deleteRows(at: [indexPath], with: .automatic)
        })
        
        let statsAction = BGTableViewRowActionWithImage.rowAction(with: .normal, title: "    ", backgroundColor: UIColor.green, image: UIImage(named: "diagram"), forCellHeight: 100, handler: { (action, indexpath) in
            self.present(TimerStatisticVC(), animated: true, completion: nil)
        })
       
        
        return [deleteAction!, statsAction!]
    }

}
