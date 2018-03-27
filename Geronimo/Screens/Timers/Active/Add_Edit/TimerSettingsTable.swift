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
    var vc: UIViewController?
    var picker: DateTimePicker = DateTimePicker()
    
    let typePicker = TypePeriodPicker()
    
    var sectionHeaders: [String]?
    var cellTitles: [[String]]?
    var cellValues: [[Any]]?
    
    let cellSwitchName = "LabelSwitchCell"
    let cellLabelsName = "LabelLabelCell"
    let cellArrowName = "LabelArrowCell"
    
    public let cellHeight: CGFloat = 44.0
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        register(UINib.init(nibName: cellSwitchName, bundle: Bundle.main), forCellReuseIdentifier: cellSwitchName)
        register(UINib.init(nibName: cellLabelsName, bundle: Bundle.main), forCellReuseIdentifier: cellLabelsName)
        register(UINib.init(nibName: cellArrowName, bundle: Bundle.main), forCellReuseIdentifier: cellArrowName)
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(cellTitles: [[String]], cellValues: [[Any]], sectionHeaders: [String], timer: Timer, vc: UIViewController){
        self.cellTitles = cellTitles
        self.cellValues = cellValues
        self.sectionHeaders = sectionHeaders
        self.rowHeight = self.cellHeight
        self.timer = timer
        self.typePicker.timer = timer
        self.vc = vc
    }
    
    func updateDataSource(){
        guard let timer = self.timer else {
            return
        }
        switch timer.type {
        case TimerData.TimerType.down.rawValue:
            self.sectionHeaders = ["", "Repeats","Begin","End","Worked Time"]
            self.cellTitles = [["Type", "Period"], ["Infinetily", "Repeats"], ["Now", "Date", "Time"], ["Never", "Date", "Time"], ["Only worked time", "Begin", "End"] ]
            self.cellValues = [ [timer.type, timer.period], [timer.isInfinetily, timer.repeats], [timer.isNow, timer.beginDate, timer.beginTime], [timer.isNever, timer.endDate, timer.endTime], [timer.isOnlyWorked, timer.beginWorkTime, timer.endWorkTime] ]
        case TimerData.TimerType.up.rawValue:
            self.sectionHeaders = ["", "Begin"]
            self.cellTitles = [["Type"], ["Now", "Date", "Time"]]
            self.cellValues = [ [timer.type], [timer.isNow, timer.beginDate, timer.beginTime] ]
        default:
            return
        }
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
                typePicker.showTypePicker(fromController: self.vc!){ completion in
                    if(completion){
                        if let type = self.typePicker.timer?.type {
                            self.cellValues![section][row] = type
                            self.timer?.type = type
                            self.updateDataSource()
                            self.reloadData()
                        }
                    }
                }
            case 1:
                typePicker.showPeriodPicker(fromController: self.vc!){ completion in
                    if(completion){
                        self.cellValues![section][row] = self.typePicker.period!
                        self.timer?.period = self.typePicker.period!
                        self.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            default:
                break
            }
        case 1:
            switch row{
            case 1:
                picker.showCountPicker(fromController: self.vc!) { completion in
                    if (completion) {
                        if let count = self.picker.count {
                            self.cellValues![section][row] = count
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
                picker.showDatePicker(fromController: self.vc!) { completion in
                    if(completion){
                        if let date = self.picker.date{
                            self.cellValues![section][row] = Calendar.current.dateComponents([ .day, .month, .year], from: date)
                            self.timer?.beginDate = Calendar.current.dateComponents([ .day, .month, .year], from: date)
                            self.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            case 2:
                picker.showTimePicker(fromController: self.vc!) { completion in
                    if(completion){
                        if let time = self.picker.time{
                            self.timer?.beginTime = Calendar.current.dateComponents([ .hour, .minute], from: time)
                            self.cellValues![section][row] = self.timer!.beginTime
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
                picker.showDatePicker(fromController: self.vc!) { completion in
                    if(completion){
                        if let date = self.picker.date{
                            self.cellValues![section][row] = Calendar.current.dateComponents([ .day, .month, .year], from: date)
                            self.timer?.endDate = Calendar.current.dateComponents([ .day, .month, .year], from: date)
                            self.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            case 2:
                picker.showTimePicker(fromController: self.vc!){ completion in
                    if(completion){
                        if let time = self.picker.time{
                            self.timer?.endTime = Calendar.current.dateComponents([ .hour, .minute], from: time)
                            self.cellValues![section][row] = self.timer!.endTime
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
                picker.showTimePicker(fromController: self.vc!){ completion in
                }
                if let time = self.picker.time {
                    self.timer?.beginWorkTime = Calendar.current.dateComponents([ .hour, .minute], from: time)
                    self.cellValues![section][row] = self.timer!.beginWorkTime
                    self.reloadRows(at: [indexPath], with: .automatic)
                }
            case 2:
                picker.showTimePicker(fromController: self.vc!){ completion in
                }
                if let time = self.picker.time {
                    self.timer?.endWorkTime = Calendar.current.dateComponents([ .hour, .minute], from: time)
                    self.cellValues![section][row] = self.timer!.endWorkTime
                    self.reloadRows(at: [indexPath], with: .automatic)
                }
                break
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
