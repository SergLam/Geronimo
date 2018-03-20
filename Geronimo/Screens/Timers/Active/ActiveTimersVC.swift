//
//  ActiveTimersVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/20/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

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
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
            print("Delete Action Tapped")
        }
        deleteAction.backgroundColor = UIColor.red
        let statsAction = UITableViewRowAction(style: .destructive, title: "Stats") { (action, indexpath) in
            print("Stats Action Tapped")
        }
        deleteAction.backgroundColor = UIColor.green
        return [deleteAction, statsAction]
    }

}
