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
    
    let cellName = "ActiveTimerTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTable()
        // Do any additional setup after loading the view.
    }
    
    func configureTable(){
        activeTimersTable.register(UINib(nibName: cellName, bundle: Bundle.main), forCellReuseIdentifier: cellName)
        activeTimersTable.delegate = self
        activeTimersTable.dataSource = self
        activeTimersTable.rowHeight = 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activeTimersTable.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! ActiveTimerTableCell
        return cell
        
    }
    
    // MARK: Add actions to table
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let deleteAction = BGTableViewRowActionWithImage.rowAction(with: .destructive, title: "    ", backgroundColor: UIColor.red, image: UIImage(named: "trash_can"), forCellHeight: 100, handler: { (action, indexpath) in
            print("Delete Action Tapped")
        })
        
        let statsAction = BGTableViewRowActionWithImage.rowAction(with: .normal, title: "    ", backgroundColor: UIColor.green, image: UIImage(named: "diagram"), forCellHeight: 100, handler: { (action, indexpath) in
            self.present(TimerStatisticVC(), animated: true, completion: nil)
        })
       
        
        return [deleteAction!, statsAction!]
    }

}
