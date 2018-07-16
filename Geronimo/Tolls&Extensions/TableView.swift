//
//  TableViewRowAction.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/21/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

extension UITableViewRowAction {
    
    func setIcon(iconImage: UIImage, backColor: UIColor, cellHeight: CGFloat, iconSizePercentage: CGFloat)
    {
        let iconHeight = cellHeight * iconSizePercentage
        let margin = (cellHeight - iconHeight) / 2 as CGFloat
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: cellHeight, height: cellHeight), false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        backColor.setFill()
        context!.fill(CGRect(x:0, y:0, width:cellHeight, height:cellHeight))
        
        iconImage.draw(in: CGRect(x: margin, y: margin, width: iconHeight, height: iconHeight))
        
        let actionImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.backgroundColor = UIColor.init(patternImage: actionImage!)
    }
}

extension UITableView{
    
    func showHideCell(cell: UITableViewCell?, isSwitch: Bool){
        if let cell = cell{
            if(isSwitch){
                cell.isUserInteractionEnabled = false
                cell.isHidden = true
            } else {
                cell.isUserInteractionEnabled = true
                cell.isHidden = false
            }
        }
    }
    
}

extension UITableViewDelegate{
    
    func getCellHeight(isVisible: Any) -> CGFloat{
        let cellHeight: CGFloat = 44.0
        if let visible = isVisible as? Bool{
            if(visible){
                return 0.0
            } else {
                return cellHeight
            }
        } else {
            return cellHeight
        }
    }
    
}
