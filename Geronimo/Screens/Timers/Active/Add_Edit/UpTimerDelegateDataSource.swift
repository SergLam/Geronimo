//
//  UpTimerDelegateDataSource.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/27/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class UpTimerDelegateDataSource: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    var sectionHeaders: [String]?
    var cellTitles: [[String]]?
    var cellValues: [[Any]]?
    
    var table: TimerSettingsTable?
    
    let cellSwitchName = "LabelSwitchCell"
    let cellLabelsName = "LabelLabelCell"
    let cellArrowName = "LabelArrowCell"
    
    func setData(timer: GeronimoTimer, table: TimerSettingsTable){
        self.sectionHeaders = ["", "Begin"]
        self.cellTitles = [["Type"],["Now", "Date", "Time"]]
        self.cellValues = [ [timer.type],
                            [timer.isNow, timer.beginDate, Calendar.current.dateComponents([.hour, .minute], from: timer.beginDate)] ]
        self.table = table
    }
    
    // MARK: Table View sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders!.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(sectionHeaders![section] == ""){
            return nil
        } else {
            return sectionHeaders?[section]
        }
    }
    
    // MARK: Table View cells
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles![section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        let titles = cellTitles![section]
        let values = cellValues![section]
        
        switch section {
        case 0:
            switch row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellArrowName, for: indexPath) as! LabelArrowCell
                 cell.updateCell(title: titles[row], description: String(describing: values[row]))
                return cell
            default:
                break
            }
        case 1:
            switch row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellSwitchName, for: indexPath) as! LabelSwitchCell
                cell.updateCell(name: titles[row], isEnabled: values[row] as! Bool)
                cell.isSwitchEnabled = { [unowned self] isSelected in
                    self.cellValues?[section][row] = isSelected
                    let second_cell = self.table?.cellForRow(at: IndexPath(row: row+1, section: section))
                    let third_cell = self.table?.cellForRow(at: IndexPath(row: row+2, section: section))
                    self.table?.showHideCell(cell: second_cell, isSwitch: isSelected)
                    self.table?.showHideCell(cell: third_cell, isSwitch: isSelected)
                    self.table?.reloadData()
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as! LabelLabelCell
                changeCellState(cell: cell, isEnabled: values[row-1] as! Bool)
                if let date = values[row] as? Date{
                    cell.updateCell(name: titles[row], info: cell.formatDate(date: date, type: UITableViewCell.dateType.date.rawValue ))
                } else {
                    cell.updateCell(name: titles[row], info: String(describing: values[row]))
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as! LabelLabelCell
                changeCellState(cell: cell, isEnabled: values[row-2] as! Bool)
                if let date = values[row] as? Date{
                    cell.updateCell(name: titles[row], info: cell.formatDate(date: date, type: UITableViewCell.dateType.time.rawValue ))
                } else {
                    cell.updateCell(name: titles[row], info: String(describing: values[row]))
                }
                return cell
            default:
                break
            }
        default:
            break
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
                table?.typePicker.showTypePicker(){ completion in
                    if(completion){
                        if let type = self.table!.typePicker.timer?.type {
                            self.table?.timer?.type = type
                            self.cellValues![section][row] = type
                            self.table?.updateTableCellValues()
                            self.table?.updateDataSource()
                            self.table?.reloadData()
                        }
                    }
                }
            default:
                break
            }
        case 1:
            switch row{
            case 1:
                table?.picker.showDatePicker() { completion in
                    if(completion){
                        if let date = self.table!.picker.date{
                            guard let begin = self.table?.timer?.beginDate else{
                                return
                            }
                            let calendar = Calendar.current
                            let new = calendar.dateComponents([.year, .month, .day], from: date)
                            let old = calendar.dateComponents([.hour, .minute, .second], from: begin)
                            var new_components = DateComponents()
                            new_components.year = new.year
                            new_components.month = new.month
                            new_components.day = new.day
                            new_components.hour = old.hour
                            new_components.minute = old.minute
                            new_components.second = old.second
                            
                            let new_date = calendar.date(from: new_components)!
                            
                            self.table?.timer?.beginDate = new_date
                            self.cellValues![section][row] = new_date
                            self.table?.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            case 2:
                table?.picker.showTimePicker() { completion in
                    if let time = self.table!.picker.time{
                        guard let begin = self.table?.timer?.beginDate else{
                            return
                        }
                        let calendar = Calendar.current
                        let new = calendar.dateComponents([.hour, .minute, .second], from: time)
                        let old = calendar.dateComponents([.year, .month, .day], from: begin)
                        var new_components = DateComponents()
                        new_components.second = new.second
                        new_components.minute = new.minute
                        new_components.hour = new.hour
                        new_components.day = old.day
                        new_components.month = old.month
                        new_components.year = old.year
                        
                        let new_time = calendar.date(from: new_components)!
                        
                        self.table?.timer?.beginDate = new_time
                        self.cellValues![section][row] = new_time
                        self.table?.reloadRows(at: [indexPath], with: .automatic)
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
        
        let values = cellValues![section]
        let cellHeight: CGFloat = 44.0
        
        switch section {
        case 0:
            return cellHeight
        case 1:
            switch row {
            case 0:
                return cellHeight
            case 1:
                return self.getCellHeight(isVisible: values[row-1])
            case 2:
                return self.getCellHeight(isVisible: values[row-1])
            default:
                return cellHeight
            }
        default:
            return cellHeight
        }
    }
    
    // MARK: Cell State
    func changeCellState(cell: UITableViewCell, isEnabled: Bool){
        if(isEnabled){
            cell.isUserInteractionEnabled = false
            cell.isHidden = true
        } else {
            cell.isUserInteractionEnabled = true
            cell.isHidden = false
        }
    }
    
    
}
