//
//  EndedTimersVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/20/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class EndedTimersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableEndedTimers: UITableView!
    
    let cellName = "EndedTimerTableCell"
    
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
    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableEndedTimers.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! EndedTimerTableCell
        return cell
    }


}
