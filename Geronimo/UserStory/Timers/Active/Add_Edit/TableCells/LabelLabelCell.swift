//
//  LabelLabelCell.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/23/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

final class LabelLabelCell: UITableViewCell {

    @IBOutlet private weak var cellName: UILabel!
    
    @IBOutlet private weak var cellInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(name: String, info: String){
        self.cellName.text = name
        self.cellInfo.text = info
    }
    
}
