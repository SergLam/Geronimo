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
    // MARK: Add actions to table
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let completeAction = BGTableViewRowActionWithImage.rowAction(with: .destructive, title: "    ", backgroundColor: UIColor.green, image: UIImage(named: "check_mark"), forCellHeight: 100, handler: { (action, indexpath) in
            self.endedTimers.remove(at: indexPath.row)
            self.tableEndedTimers.deleteRows(at: [indexPath], with: .automatic)
        })
        
        
        
        
        return [completeAction!]
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
