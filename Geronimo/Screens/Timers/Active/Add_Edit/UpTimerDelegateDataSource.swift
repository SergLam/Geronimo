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
    var vc: UIViewController?
    
    let cellSwitchName = "LabelSwitchCell"
    let cellLabelsName = "LabelLabelCell"
    let cellArrowName = "LabelArrowCell"
    
    func setData(timer: Timer, table: TimerSettingsTable, vc: UIViewController){
        self.sectionHeaders = ["", "Begin"]
        self.cellTitles = [["Type"],["Now", "Date", "Time"]]
        self.cellValues = [ [timer.type],
                            [timer.isNow, timer.beginDate, timer.beginTime] ]
        self.table = table
        self.vc = vc
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
                            self.table?.timer?.beginDate = date
                            self.cellValues![section][row] = date
                            self.table?.updateTableCellValues()
                            self.table?.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            case 2:
                table?.picker.showTimePicker() { completion in
                    if(completion){
                        if let time = self.table!.picker.time{
                            self.table?.timer?.beginTime = time
                            self.table?.updateTableCellValues()
                            self.cellValues![section][row] = time
                            self.table?.reloadRows(at: [indexPath], with: .automatic)
                        }
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
        switch section {
        case 0:
            return UITableViewAutomaticDimension
        case 1:
            switch row {
            case 0:
                return UITableViewAutomaticDimension
            case 1:
                if let isVisible = values[row-1] as? Bool{
                    if(isVisible){
                        return 0.0
                    } else {
                        return UITableViewAutomaticDimension
                    }
                } else {
                    return UITableViewAutomaticDimension
                }
            case 2:
                if let isVisible = values[row-2] as? Bool{
                    if(isVisible){
                        return 0.0
                    } else {
                        return UITableViewAutomaticDimension
                    }
                } else {
                    return UITableViewAutomaticDimension
                }
            default:
                return UITableViewAutomaticDimension
            }
        default:
            return UITableViewAutomaticDimension
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
