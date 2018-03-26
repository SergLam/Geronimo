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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(name: String, isEnabled: Bool){
        cellName.text = name
        cellSwitch.isOn = isEnabled
        changeSectionCellsState(isSwitch: cellSwitch.isOn)
    }
    
    @IBAction func onSwitchClick(_ sender: UISwitch) {
        let isSwitch = sender.isOn
        changeSectionCellsState(isSwitch: isSwitch)
    }
    
    func changeSectionCellsState(isSwitch: Bool){
        // Get cell table - superview (owner)
        if let superView = self.superview{
            if(superView.isKind(of: UITableView.self)){
                let table = superView as! TimerSettingsTable
                // Get cell index
                if let index = table.indexPath(for: self){
                    // Build section cell indexes
                    let secondCellIndex = IndexPath(row: index.row+1, section: index.section)
                    let thirdCellIndex = IndexPath(row: index.row+2, section: index.section)
                    // Disable / Enable cells on switch state
                    if let second_cell = table.cellForRow(at: secondCellIndex){
                        if(isSwitch){
                            second_cell.isUserInteractionEnabled = isSwitch
                            second_cell.backgroundColor = .green
                        } else {
                            second_cell.isUserInteractionEnabled = isSwitch
                            second_cell.backgroundColor = .red
                        }
                    }
                    if let third_cell = table.cellForRow(at: thirdCellIndex){
                        if(isSwitch){
                            third_cell.isUserInteractionEnabled = isSwitch
                            third_cell.backgroundColor = .green
                        } else {
                            third_cell.isUserInteractionEnabled = isSwitch
                            third_cell.backgroundColor = .red
                        }
                    }
                    
                }
            }
        }
    }
    
}
