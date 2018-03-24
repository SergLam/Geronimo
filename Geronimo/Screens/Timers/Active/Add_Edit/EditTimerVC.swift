//
//  EditTimerVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/21/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import SnapKit

class EditTimerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var timerTitle: UITextField!
    
    @IBOutlet weak var timerNotes: UITextField!
    
    @IBOutlet weak var timerSettings: UITableView!
    
    let cellName = "LabelArrowCell"
    
    var timer: Timer?
    
    // Settings Tables
    var settingsTable: TimerSettingsTable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        initSettingsTables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureTable(){
        timerSettings.register(UINib(nibName: cellName, bundle: Bundle.main), forCellReuseIdentifier: cellName)
        timerSettings.delegate = self
        timerSettings.dataSource = self
        timerSettings.rowHeight = 44
        timerSettings.sizeToFit()
    }
    
    func setTimer(timer: Timer){
        self.timer = timer
    }
    
    func initSettingsTables(){
      // Get Timer type
      self.settingsTable = TimerSettingsTable.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: TimerSettingsTable().cellHeight * 3), style: UITableViewStyle.grouped)
        let sectionHeaders = ["Repeats","Begin","End","Worked Time"]
        let cellTitles = [ ["Infinetily", "Repeats"], ["Now", "Date", "Time"], ["Never", "Date", "Time"], ["Only worked time", "Begin", "End"] ]
        guard let timer = self.timer else {
            return
        }
        let cellValues = [ [timer.isInfinetily, timer.repeats], [timer.isNow, timer.beginDate, timer.beginTime], [timer.isNever, timer.endDate, timer.endTime], [timer.isOnlyWorked, timer.beginWorkTime, timer.endWorkTime] ]
        settingsTable!.setData(cellTitles: cellTitles, cellValues: cellValues, sectionHeaders: sectionHeaders, timer: timer)
        self.contentView.addSubview(settingsTable!)
        settingsTable!.reloadData()
        settingsTable!.snp_makeConstraints{(make) -> Void in
            make.right.equalTo(self.view).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.top.equalTo(timerSettings).offset(timerSettings.frame.height)
            make.height.equalTo(settingsTable!.contentSize.height+100)
        }
    }
        
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBarButton(_ sender: UIBarButtonItem) {
        // TODO: function to save changes
        self.dismiss(animated: true, completion: nil)
    }
    
    // Table View Data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch timer!.type {
        case TimerData.TimerType.up.rawValue:
            return 1
        case TimerData.TimerType.down.rawValue:
            return 2
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timerSettings.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! LabelArrowCell
        switch indexPath.row {
        case 0:
            cell.updateCell(title: "Type", description: self.timer!.type)
        case 1:
            cell.updateCell(title: "Period", description: self.formatDate(date: self.timer!.period))
        default:
            break
        }
        return cell
    }
}
