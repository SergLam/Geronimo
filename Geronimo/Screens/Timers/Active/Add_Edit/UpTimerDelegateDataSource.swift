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
    
    var timer: Timer?
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
        self.timer = timer
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
                changeCellState(cell: cell, isEnabled: values[row-1] as! Bool)
                if let date = values[row] as? DateComponents{
                    cell.updateCell(name: titles[row], info: self.formatDate(date: date ))
                } else {
                    cell.updateCell(name: titles[row], info: String(describing: values[row]))
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as! LabelLabelCell
                changeCellState(cell: cell, isEnabled: values[row-2] as! Bool)
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
                            self.cellValues![section][row] = type
                            self.timer?.type = type
                            self.table?.updateDataSource()
                            self.table?.reloadData()
                        }
                    }
                }
            case 1:
                table?.typePicker.showPeriodPicker(fromController: self.vc!){ completion in
                    if(completion){
                        self.cellValues![section][row] = self.table!.typePicker.period!
                        self.timer?.period = self.table!.typePicker.period!
                        self.table?.reloadRows(at: [indexPath], with: .automatic)
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
                            self.cellValues![section][row] = Calendar.current.dateComponents([ .day, .month, .year], from: date)
                            self.timer?.beginDate = Calendar.current.dateComponents([ .day, .month, .year], from: date)
                            self.table?.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
                case 2:
                    table?.picker.showTimePicker(fromController: self.vc!) { completion in
                        if(completion){
                            if let time = self.table!.picker.time{
                                self.timer?.beginTime = Calendar.current.dateComponents([ .hour, .minute], from: time)
                                self.cellValues![section][row] = self.timer!.beginTime
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
    
    // MARK: Cell State
    func changeCellState(cell: UITableViewCell, isEnabled: Bool){
        if(isEnabled){
            cell.isUserInteractionEnabled = true
            cell.backgroundColor = .green
        } else {
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = .red
        }
    }
    
    
}
