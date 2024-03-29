//
//  LabelSwitchCell.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/23/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

final class LabelSwitchCell: UITableViewCell {

    @IBOutlet private weak var cellName: UILabel!
    
    @IBOutlet private weak var cellSwitch: UISwitch!
    
    var isSwitchEnabled: ((_ isSelected: Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(name: String, isEnabled: Bool){
        cellName.text = name
        cellSwitch.isOn = isEnabled
    }
    
    @IBAction func onSwitchClick(_ sender: UISwitch) {
        isSwitchEnabled?(sender.isOn)
    }
    
}
