//
//  TimerSettingsTableView.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/23/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

final class TimerSettingsTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var timer: GeronimoTimer?
    var picker: DateTimePicker = DateTimePicker()
    
    let typePicker = TypePeriodPicker()
    let upTimerDataSource = UpTimerDelegateDataSource()
    
    var sectionHeaders: [String] = []
    var cellTitles: [[String]] = []
    var cellValues: [[Any]] = []
    
    let cellSwitchName = "LabelSwitchCell"
    let cellLabelsName = "LabelLabelCell"
    let cellArrowName = "LabelArrowCell"
    
    public let cellHeight: CGFloat = 44.0
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(UINib(nibName: cellSwitchName, bundle: Bundle.main), forCellReuseIdentifier: cellSwitchName)
        register(UINib(nibName: cellLabelsName, bundle: Bundle.main), forCellReuseIdentifier: cellLabelsName)
        register(UINib(nibName: cellArrowName, bundle: Bundle.main), forCellReuseIdentifier: cellArrowName)
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(cellTitles: [[String]], cellValues: [[Any]], sectionHeaders: [String], timer: GeronimoTimer){
        self.cellTitles = cellTitles
        self.cellValues = cellValues
        self.sectionHeaders = sectionHeaders
        self.rowHeight = self.cellHeight
        self.timer = timer
        self.typePicker.timer = timer
    }
    
    func updateTableCellValues(){
        guard let timer = self.timer else {
            return
        }
        self.cellValues = [ [timer.type, timer.period], [timer.isInfinetily, timer.repeats], [timer.isNow, timer.beginDate, timer.beginDate], [timer.isNever, timer.endDate, timer.endDate], [timer.isOnlyWorked, timer.beginWorkTime, timer.endWorkTime] ]
    }
    
    func updateDataSource(){
        guard let timer = self.timer else {
            return
        }
        switch timer.type {
        case TimerData.TimerType.down.rawValue:
            self.dataSource = self
            self.delegate = self
        case TimerData.TimerType.up.rawValue:
            self.upTimerDataSource.setData(timer: timer, table: self)
            self.dataSource = upTimerDataSource
            self.delegate = upTimerDataSource
        default:
            return
        }
    }
    
    // MARK: Table View sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionHeaders[section].isEmpty {
            return nil
        } else {
            return sectionHeaders[section]
        }
    }
    
    // MARK: Table View cells
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        let titles = cellTitles[section]
        let values = cellValues[section]
        
        switch section {
        case 0:
            switch row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellArrowName, for: indexPath) as? LabelArrowCell else {
                    assertionFailure("Unable to dequeueReusableCell id - \(cellArrowName)")
                    return UITableViewCell()
                }
                cell.updateCell(title: titles[row], description: String(describing: values[row]))
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellArrowName, for: indexPath) as? LabelArrowCell else {
                    assertionFailure("Unable to dequeueReusableCell id - \(cellArrowName)")
                    return UITableViewCell()
                }
                if let interval = values[row] as? TimeInterval{
                    cell.updateCell(title: titles[row], description: cell.formatInterval(duration: interval))
                    return cell
                }
            default:
                break
            }
            // ONLY WORKED TIME
        case 4:
            switch row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellSwitchName, for: indexPath) as? LabelSwitchCell else {
                    assertionFailure("Unable to dequeueReusableCell id - \(cellSwitchName)")
                    return UITableViewCell()
                }
                cell.updateCell(name: titles[row], isEnabled: (values[row] as? Bool) ?? false)
                cell.isSwitchEnabled = { [unowned self] isSelected in
                    self.timer?.isOnlyWorked = isSelected
                    self.cellValues[section][row] = isSelected
                    let second_cell = self.cellForRow(at: IndexPath(row: row + 1, section: section))
                    let third_cell = self.cellForRow(at: IndexPath(row: row + 2, section: section))
                    self.showHideCell(cell: second_cell, isSwitch: !isSelected)
                    self.showHideCell(cell: third_cell, isSwitch: !isSelected)
                    self.reloadData()
                }
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as? LabelLabelCell else {
                    assertionFailure("Unable to dequeueReusableCell id - \(cellLabelsName)")
                    return UITableViewCell()
                }
                self.showHideCell(cell: cell, isSwitch: !((values[row - 1] as? Bool) ?? false) )
                if let date = values[row] as? Date{
                    cell.updateCell(name: titles[row], info: cell.formatDate(date: date, type: UITableViewCell.DateType.time.rawValue ))
                } else {
                    cell.updateCell(name: titles[row], info: String(describing: values[row]))
                }
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as? LabelLabelCell else {
                    assertionFailure("Unable to dequeueReusableCell id - \(cellLabelsName)")
                    return UITableViewCell()
                }
                self.showHideCell(cell: cell, isSwitch: !((values[row - 2] as? Bool) ?? false) )
                if let date = values[row] as? Date{
                    cell.updateCell(name: titles[row], info: cell.formatDate(date: date, type: UITableViewCell.DateType.time.rawValue ))
                } else {
                    cell.updateCell(name: titles[row], info: String(describing: values[row]))
                }
                return cell
            default:
                break
            }
        default:
            switch row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellSwitchName, for: indexPath) as? LabelSwitchCell else {
                    assertionFailure("Unable to dequeueReusableCell id - \(cellSwitchName)")
                    return UITableViewCell()
                }
                cell.updateCell(name: titles[row], isEnabled: (values[row] as? Bool) ?? false)
                cell.isSwitchEnabled = { [unowned self] isSelected in
                    switch section{
                    case 1:
                        self.timer?.isInfinetily = isSelected
                    case 2:
                        self.timer?.isNow = isSelected
                    case 3:
                        self.timer?.isNever = isSelected
                    default:
                        break
                    }
                    self.cellValues[section][row] = isSelected
                    let second_cell = self.cellForRow(at: IndexPath(row: row + 1, section: section))
                    let third_cell = self.cellForRow(at: IndexPath(row: row + 2, section: section))
                    self.showHideCell(cell: second_cell, isSwitch: isSelected)
                    self.showHideCell(cell: third_cell, isSwitch: isSelected)
                    self.reloadData()
                }
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as? LabelLabelCell else {
                    assertionFailure("Unable to dequeueReusableCell id - \(cellLabelsName)")
                    return UITableViewCell()
                }
                self.showHideCell(cell: cell, isSwitch: !((values[row - 1] as? Bool) ?? false))
                if let date = values[row] as? Date{
                    cell.updateCell(name: titles[row], info: cell.formatDate(date: date, type: UITableViewCell.DateType.date.rawValue ))
                } else {
                    cell.updateCell(name: titles[row], info: String(describing: values[row]))
                }
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as? LabelLabelCell else {
                    assertionFailure("Unable to dequeueReusableCell id - \(cellLabelsName)")
                    return UITableViewCell()
                }
                self.showHideCell(cell: cell, isSwitch: !((values[row - 2] as? Bool) ?? false)  )
                if let date = values[row] as? Date{
                    cell.updateCell(name: titles[row], info: cell.formatDate(date: date, type: UITableViewCell.DateType.time.rawValue ))
                } else {
                    cell.updateCell(name: titles[row], info: String(describing: values[row]))
                }
                return cell
            default:
                break
            }
        }
        return UITableViewCell()
    }
    
    // MARK: Cell Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        switch section {
        case 0:
            switch row{
            case 0:
                typePicker.showTypePicker{ completion in
                    if completion {
                        if let type = self.typePicker.timer?.type {
                            self.cellValues[section][row] = type
                            self.timer?.type = type
                            self.updateDataSource()
                            self.reloadData()
                        }
                    }
                }
            case 1:
                typePicker.showPeriodPicker{ completion in
                    if completion {
                        self.cellValues[section][row] = self.typePicker.period ?? 0
                        self.timer?.period = self.typePicker.period ?? 0
                        self.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            default:
                break
            }
        case 1:
            switch row{
            case 1:
                picker.showCountPicker { completion in
                    if completion {
                        if let count = self.picker.count {
                            self.cellValues[section][row] = count
                            self.timer?.repeats = count
                            self.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            default:
                break
            }
        case 2:
            switch row{
            case 1:
                picker.showDatePicker { completion in
                    if completion {
                        if let date = self.picker.date{
                            guard let begin = self.timer?.beginDate else{
                                 return
                            }
                            let new_date = self.changeOnlyDateInDate(old_date: begin, new_date: date)
                            
                            self.cellValues[section][row] = new_date
                            self.timer?.beginDate = new_date
                            self.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            case 2:
                picker.showTimePicker { completion in
                    if completion {
                        if let time = self.picker.time{
                            guard let begin = self.timer?.beginDate else{
                                return
                            }
                            let new_time = self.changeOnlyTimeInDate(old_date: begin, new_date: time)
                            
                            self.timer?.beginDate = new_time
                            self.cellValues[section][row] = new_time
                            self.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            default:
                break
            }
        case 3:
            switch row{
            case 1:
                picker.showDatePicker { completion in
                    if completion {
                        if let date = self.picker.date{
                            guard let end = self.timer?.endDate else{
                                return
                            }
                            let new_date = self.changeOnlyDateInDate(old_date: end, new_date: date)
                            
                            self.timer?.endDate = new_date
                            self.cellValues[section][row] = new_date
                            self.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            case 2:
                picker.showTimePicker { completion in
                    if completion {
                        if let time = self.picker.time{
                            guard let end = self.timer?.endDate else{
                                return
                            }
                            let new_time = self.changeOnlyTimeInDate(old_date: end, new_date: time)
                            
                            self.timer?.endDate = new_time
                            self.cellValues[section][row] = new_time
                            self.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            default:
                break
            }
        case 4:
            switch row{
            case 1:
                picker.showTimePicker{ _ in
                if let time = self.picker.time {
                    self.timer?.beginWorkTime = time
                    self.cellValues[section][row] = time
                    self.reloadRows(at: [indexPath], with: .automatic)
                }
                }
            case 2:
                picker.showTimePicker{ _ in
                if let time = self.picker.time {
                    self.timer?.endWorkTime = time
                    self.cellValues[section][row] = time
                    
                    self.reloadRows(at: [indexPath], with: .automatic)
                }
                }
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        let values = cellValues[section]
        let cellHeight: CGFloat = 44.0
        
        switch section {
        case 0:
           return cellHeight
        case 4:
            switch row {
            case 0:
                return cellHeight
            case 1:
                return self.getCellHeight(isVisible: values[row - 1])
            case 2:
                return self.getCellHeight(isVisible: values[row - 2])
            default:
                return cellHeight
            }
        default:
            switch row {
            case 0:
                return 44.0
            case 1:
                return self.getCellHeight(isVisible: values[row - 1])
            case 2:
                return self.getCellHeight(isVisible: values[row - 2])
            default:
                return cellHeight
            }
        }
    }
    
}
