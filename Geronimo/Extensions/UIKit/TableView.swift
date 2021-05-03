//
//  TableViewRowAction.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/21/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

extension UITableViewRowAction {
    
    func setIcon(iconImage: UIImage, backColor: UIColor, cellHeight: CGFloat, iconSizePercentage: CGFloat) {
        
        let iconHeight = cellHeight * iconSizePercentage
        let margin = (cellHeight - iconHeight) / 2 as CGFloat
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: cellHeight, height: cellHeight), false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        backColor.setFill()
        context.fill(CGRect(x: 0, y: 0, width: cellHeight, height: cellHeight))
        
        iconImage.draw(in: CGRect(x: margin, y: margin, width: iconHeight, height: iconHeight))
        
        guard let actionImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        UIGraphicsEndImageContext()
        
        self.backgroundColor = UIColor(patternImage: actionImage)
    }
}

extension UITableView{
    
    func showHideCell(cell: UITableViewCell?, isSwitch: Bool){
        if let cell = cell{
            if isSwitch {
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
            return visible ? cellHeight : 0.0
        } else {
            return cellHeight
        }
    }
    
    func showHideCell(cell: UITableViewCell?, isSwitch: Bool){
        if let cell = cell{
            if isSwitch {
                cell.isUserInteractionEnabled = false
                cell.isHidden = true
            } else {
                cell.isUserInteractionEnabled = true
                cell.isHidden = false
            }
        }
    }
    
    func changeOnlyDateInDate(old_date: Date, new_date: Date) -> Date{
        let calendar = Calendar.current
        let new = calendar.dateComponents([.year, .month, .day], from: new_date)
        let old = calendar.dateComponents([.hour, .minute, .second], from: old_date)
        var new_components = DateComponents()
        new_components.year = new.year
        new_components.month = new.month
        new_components.day = new.day
        new_components.hour = old.hour
        new_components.minute = old.minute
        new_components.second = old.second
        
        let new_date = calendar.date(from: new_components) ?? Date()
        return new_date
    }
    
    func changeOnlyTimeInDate(old_date: Date, new_date: Date) -> Date{
        let calendar = Calendar.current
        let new = calendar.dateComponents([.hour, .minute, .second], from: new_date)
        let old = calendar.dateComponents([.year, .month, .day], from: old_date)
        var new_components = DateComponents()
        new_components.second = new.second
        new_components.minute = new.minute
        new_components.hour = new.hour
        new_components.day = old.day
        new_components.month = old.month
        new_components.year = old.year
        
        let new_time = calendar.date(from: new_components) ?? Date()
        return new_time
    }
    
}
