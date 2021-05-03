//
//  LabelArrowCell.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/23/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

final class LabelArrowCell: UITableViewCell {

    @IBOutlet private weak var cellTitle: UILabel!
    
    @IBOutlet private weak var cellDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryType = .disclosureIndicator
    }
    
    func updateCell(title: String, description: String){
        self.cellTitle.text = title
        self.cellDescription.text = description
    }
    
}
