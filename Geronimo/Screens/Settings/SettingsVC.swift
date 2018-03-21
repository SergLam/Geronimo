//
//  SettingsVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/21/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingTable: UITableView!
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    let cellName = "SettingsTableCell"
    
    let firstSection = ["New Feature Reuest", "Performance Feedback", "Report a Bug"]
    let secondSection = ["About Us"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettingTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK: TableView methods
    func configureSettingTable(){
        settingTable.register(UINib(nibName: cellName, bundle: Bundle.main), forCellReuseIdentifier: cellName)
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.rowHeight = 43.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTable.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! SettingsTableCell
        switch indexPath.section {
        case 0:
            cell.updateCell(name: firstSection[indexPath.row])
        case 1:
            cell.updateCell(name: secondSection[indexPath.row])
        default:
            break
        }
        return cell
    }
    
    // MARK: Section handling
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "FEEDBACK"
        case 1:
            return "MORE"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row_count = 0
        switch section {
        case 0:
            row_count = firstSection.count
        case 1:
            row_count = secondSection.count
        default:
            break
        }
        return row_count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    @IBAction func dismissSettingsVC(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
