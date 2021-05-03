//
//  SettingsTableCell.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/21/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

final class SettingsTableCell: UITableViewCell {
    
    @IBOutlet private weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(name: String){
        self.cellLabel.text = name
    }
    
}
