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
    let upTimerDataSource = UpTimerDelegateDataSource()
    
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
    
    func updateTableCellValues(){
        guard let timer = self.timer else {
            return
        }
        self.cellValues = [ [timer.type, timer.period], [timer.isInfinetily, timer.repeats], [timer.isNow, timer.beginDate, timer.beginTime], [timer.isNever, timer.endDate, timer.endTime], [timer.isOnlyWorked, timer.beginWorkTime, timer.endWorkTime] ]
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
            self.upTimerDataSource.setData(timer: timer, table: self, vc: self.vc!)
            self.dataSource = upTimerDataSource
            self.delegate = upTimerDataSource
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
            switch row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellArrowName, for: indexPath) as! LabelArrowCell
                cell.updateCell(title: titles[row], description: String(describing: values[row]))
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellArrowName, for: indexPath) as! LabelArrowCell
                if let interval = values[row] as? TimeInterval{
                    cell.updateCell(title: titles[row], description: self.formatInterval(duration: interval))
                    return cell
                }
            default:
                break
            }
        case 4:
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
                changeCellState(cell: cell, isEnabled: !(values[row-1] as! Bool) )
                if let date = values[row] as? Date{
                    cell.updateCell(name: titles[row], info: self.formatDate(date: date, type: dateType.date.rawValue ))
                } else {
                    cell.updateCell(name: titles[row], info: String(describing: values[row]))
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as! LabelLabelCell
                changeCellState(cell: cell, isEnabled: !(values[row-2] as! Bool) )
                if let date = values[row] as? Date{
                    cell.updateCell(name: titles[row], info: self.formatDate(date: date, type: dateType.time.rawValue ))
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
                    cell.updateCell(name: titles[row], info: self.formatDate(date: date, type: dateType.date.rawValue ))
                } else {
                    cell.updateCell(name: titles[row], info: String(describing: values[row]))
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellLabelsName, for: indexPath) as! LabelLabelCell
                changeCellState(cell: cell, isEnabled: values[row-2] as! Bool)
                if let date = values[row] as? Date{
                    cell.updateCell(name: titles[row], info: self.formatDate(date: date, type: dateType.time.rawValue ))
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
                            self.timer?.beginDate = date
                            self.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            case 2:
                picker.showTimePicker(fromController: self.vc!) { completion in
                    if(completion){
                        if let time = self.picker.time{
                            self.timer?.beginTime = time
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
                            self.timer?.endDate = date
                            self.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            case 2:
                picker.showTimePicker(fromController: self.vc!){ completion in
                    if(completion){
                        if let time = self.picker.time{
                            self.timer?.endTime = time
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
                if let time = self.picker.time {
                    self.timer?.beginWorkTime = time
                    self.cellValues![section][row] = self.timer!.beginWorkTime
                    self.reloadRows(at: [indexPath], with: .automatic)
                }
                }
            case 2:
                picker.showTimePicker(fromController: self.vc!){ completion in
                if let time = self.picker.time {
                    self.timer?.endWorkTime = time
                    self.cellValues![section][row] = self.timer!.endWorkTime
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
        
        let values = cellValues![section]
        
        switch section {
        case 0:
           return UITableViewAutomaticDimension
        case 4:
            switch row {
            case 0:
                return UITableViewAutomaticDimension
            case 1:
                if let isVisible = values[row-1] as? Bool{
                    if(!isVisible){
                        return 0.0
                    } else {
                        return UITableViewAutomaticDimension
                    }
                } else {
                    return UITableViewAutomaticDimension
                }
            case 2:
                if let isVisible = values[row-2] as? Bool{
                    if(!isVisible){
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
