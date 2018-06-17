//
//  EndedTimersVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/20/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import BGTableViewRowActionWithImage

class EndedTimersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableEndedTimers: UITableView!
    
    let cellName = "EndedTimerTableCell"
    
    var endedTimers = [1,2,3,4,5,6]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTable()
    }
    
    func configureTable(){
        tableEndedTimers.register(UINib(nibName: cellName, bundle: Bundle.main), forCellReuseIdentifier: cellName)
        tableEndedTimers.delegate = self
        tableEndedTimers.dataSource = self
        tableEndedTimers.rowHeight = 100.0
    }
    
    // MARK: Add action to cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let removeAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // Call action
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
        let cell = tableEndedTimers.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! EndedTimerTableCell
        return cell
    }


}
