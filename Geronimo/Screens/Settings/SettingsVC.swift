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
    
    let about = AboutVC()
    
    let firstSection = ["New Feature Reuest", "Performance Feedback", "Report a Bug"]
    let secondSection = ["About Us"]
    let sectionHeaderTitleArray = ["FEEDBACK","MORE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettingTable()
    }
    
    override func viewWillLayoutSubviews() {
       super.viewWillLayoutSubviews()
        for constraint in self.settingTable.constraints {
            if constraint.identifier == "tableHeight" {
                constraint.constant = self.settingTable.contentSize.height
            }
        }
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
        cell.selectionStyle = .none
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
    
    // MARK: Table Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 30, y: 0, width:
            settingTable.bounds.size.width, height: 30))
        
        let label = UILabel(frame: CGRect.init(x: 20, y: 15, width: settingTable.bounds.size.width, height: 20))
        label.text = self.sectionHeaderTitleArray[section]
        label.textColor = UIColor.darkGray
        label.font = label.font.withSize(12)
        returnedView.addSubview(label)
        returnedView.backgroundColor = UIColor.groupTableViewBackground
        
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    // MARK: TableRows
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
    
    // MARK: Cell clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let sendVC = SendFormVC()
            switch indexPath.row {
                
            case 0:
                sendVC.screenName = "New Feature"
                self.present(sendVC, animated: true, completion: nil)
            case 1:
                sendVC.screenName = "Feedback"
                self.present(sendVC, animated: true, completion: nil)
            case 2:
                sendVC.screenName = "Bug Report"
                self.present(sendVC, animated: true, completion: nil)
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                self.present(self.about, animated: true, completion: nil)
            default:
                break
            }
        default:
            break
        }
    }
    
    
    @IBAction func dismissSettingsVC(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
