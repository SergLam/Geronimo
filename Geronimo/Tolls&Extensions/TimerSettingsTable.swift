//
//  TimerSettingsTableView.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/23/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class TimerSettingsTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var timer: Timer?
    var tableSectionHeaders: [String]?
    var cellTitles: [[String]]?
    var cellValues: [[Any]]?
    
    let cellSwitchName = "LabelSwitchCell"
    let cellLabelsName = "LabelLabelCell"
    public let cellHeight: CGFloat = 44.0
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        register(UINib.init(nibName: cellSwitchName, bundle: Bundle.main), forCellReuseIdentifier: cellSwitchName)
        register(UINib.init(nibName: cellLabelsName, bundle: Bundle.main), forCellReuseIdentifier: cellLabelsName)
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(cellTitles: [[String]], cellValues: [[Any]], sectionHeaders: [String], timer: Timer){
        self.cellTitles = cellTitles
        self.cellValues = cellValues
        self.tableSectionHeaders = sectionHeaders
        self.rowHeight = self.cellHeight
        self.timer = timer
    }
    
    // MARK: Table View sections
    func numberOfSections(in tableView: UITableView) -> Int {
        switch timer!.type {
        case TimerData.TimerType.up.rawValue:
            return 1
        case TimerData.TimerType.down.rawValue:
            return tableSectionHeaders!.count
        default:
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSectionHeaders?[section]
    }
    
    // MARK: Table View cells
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles![section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let titles = cellTitles![section]
        let values = cellValues![section]
        
        let row = indexPath.row
        
        switch row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellSwitchName, for: indexPath) as! LabelSwitchCell
            cell.updateCell(name: titles[row], isEnabled: values[row] as! Bool)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as! LabelLabelCell
            cell.updateCell(name: titles[row], info: String(describing: values[row]) )
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as! LabelLabelCell
            cell.updateCell(name: titles[row], info: String(describing: values[row]) )
            return cell
        default:
            break
        }
        return UITableViewCell()
    }

}
