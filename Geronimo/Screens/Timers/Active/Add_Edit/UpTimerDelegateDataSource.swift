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
        self.cellTitles = [["Type"], ["Now", "Date", "Time"]]
        self.cellValues = [ [timer.type], [timer.isNow, timer.beginDate, timer.beginTime] ]
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
            let cell = tableView.dequeueReusableCell(withIdentifier: cellArrowName, for: indexPath) as! LabelArrowCell
            if let date = values[row] as? DateComponents{
                cell.updateCell(title: titles[row], description: self.formatDate(date: date ))
            } else {
                cell.updateCell(title: titles[row], description: String(describing: values[row]))
            }
            cell.updateCell(title: titles[row], description: String(describing: values[row]))
            return cell
        default:
            switch row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellSwitchName, for: indexPath) as! LabelSwitchCell
                cell.updateCell(name: titles[row], isEnabled: values[row] as! Bool)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as! LabelLabelCell
                if let date = values[row] as? DateComponents{
                    cell.updateCell(name: titles[row], info: self.formatDate(date: date ))
                } else {
                    cell.updateCell(name: titles[row], info: String(describing: values[row]))
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as! LabelLabelCell
                if let date = values[row] as? DateComponents{
                    cell.updateCell(name: titles[row], info: self.formatDate(date: date ))
                } else {
                    cell.updateCell(name: titles[row], info: String(describing: values[row]))
                }
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
    // MARK: Cell Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        switch section {
        case 0:
            switch row{
            case 0:
                table?.typePicker.showTypePicker(fromController: self.vc!){ completion in
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
                table?.picker.showDatePicker(fromController: self.vc!) { completion in
                    if(completion){
                        if let date = self.table!.picker.date{
                            let pickedDate = Calendar.current.dateComponents([ .day, .month, .year], from: date)
                            self.table?.timer?.beginDate = pickedDate
                            self.cellValues![section][row] = pickedDate
                            self.table?.updateTableCellValues()
                            self.table?.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
                case 2:
                    table?.picker.showTimePicker(fromController: self.vc!) { completion in
                        if(completion){
                            if let time = self.table!.picker.time{
                                let pickedTime = Calendar.current.dateComponents([ .hour, .minute], from: time)
                                self.table?.timer?.beginTime = pickedTime
                                self.table?.updateTableCellValues()
                                self.cellValues![section][row] = pickedTime
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
        
    
}
