//
//  SettingsTableCell.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/21/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class SettingsTableCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(name: String){
        self.cellLabel.text = name
    }
    
}
