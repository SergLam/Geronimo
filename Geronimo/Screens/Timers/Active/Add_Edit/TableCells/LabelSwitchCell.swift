//
//  LabelSwitchCell.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/23/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class LabelSwitchCell: UITableViewCell {

    @IBOutlet weak var cellName: UILabel!
    
    @IBOutlet weak var cellSwitch: UISwitch!
    
    var isSwitchEnabled: ((_ isSelected: Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(name: String, isEnabled: Bool){
        cellName.text = name
        cellSwitch.isOn = isEnabled
    }
    
    @IBAction func onSwitchClick(_ sender: UISwitch) {
        let isSwitch = sender.isOn
        isSwitchEnabled?(sender.isOn)
        changeSectionCellsState(isSwitch: isSwitch)
    }
    
    func changeSectionCellsState(isSwitch: Bool){
        // Get cell table - superview (owner)
        if let superView = self.superview{
            if(superView.isKind(of: UITableView.self)){
                let table = superView as! TimerSettingsTable
                // Get cell index
                if let index = table.indexPath(for: self){
                    // IMPORTANT: Update Timer entity
                    updateTimer(isSwitch: isSwitch, table: table, section: index.section)
                    table.cellValues![index.section][index.row] = isSwitch
                    if(table.timer!.type == TimerData.TimerType.up.rawValue){
                        table.upTimerDataSource.cellValues?[index.section][index.row] = isSwitch
                    }
                    // Build section cell indexes
                    let secondCellIndex = IndexPath(row: index.row+1, section: index.section)
                    let thirdCellIndex = IndexPath(row: index.row+2, section: index.section)
                    // Disable / Enable cells on switch state
                    var isSwitchCopy = isSwitch
                    // Only worked time
                    if(index.section == 4){
                        isSwitchCopy = !isSwitch
                    }
                    if let second_cell = table.cellForRow(at: secondCellIndex){
                        showHideCell(cell: second_cell, isSwitch: isSwitchCopy)
                    }
                    if let third_cell = table.cellForRow(at: thirdCellIndex){
                        showHideCell(cell: third_cell, isSwitch: isSwitchCopy)
                    }
                    table.reloadData()
                }
            }
        }
    }
    
    func showHideCell(cell: UITableViewCell, isSwitch: Bool){
        if(isSwitch){
            cell.isUserInteractionEnabled = isSwitch
            cell.isHidden = true
        } else {
            cell.isUserInteractionEnabled = true
            cell.isHidden = false
        }
    }
    
    func updateTimer(isSwitch: Bool, table: TimerSettingsTable, section: Int){
        if(table.timer!.type == TimerData.TimerType.up.rawValue){
            table.timer?.isNow = isSwitch
        }
        if(table.timer!.type == TimerData.TimerType.down.rawValue){
            switch section{
            case 1:
                table.timer?.isInfinetily = isSwitch
            case 2:
                table.timer?.isNow = isSwitch
            case 3:
                table.timer?.isNever = isSwitch
            case 4:
                table.timer?.isOnlyWorked = isSwitch
            default:
                break
            }
        }
    }
    
    
}
