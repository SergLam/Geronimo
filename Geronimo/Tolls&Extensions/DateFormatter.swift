//
//  DateComponentsFormatter.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/24/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

extension UIViewController{
    
    enum dateType: String {
        case date = "date"
        case time = "time"
    }
    
    func formatDate(date: Date, type: String) -> String{
        let formatter = DateFormatter()
        
        if(type == dateType.date.rawValue){
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: date)
        }
        
        if(type == dateType.time.rawValue){
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
        return ""
    }
    
    func formatInterval(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration)!
    }
}

extension UITableViewCell {
    
    enum dateType: String {
        case date = "date"
        case time = "time"
    }
    
    func formatDate(date: Date, type: String) -> String{
        let formatter = DateFormatter()
        
        if(type == dateType.date.rawValue){
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: date)
        }
        
        if(type == dateType.time.rawValue){
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
        return ""
    }
    
    func formatInterval(duration: TimeInterval) -> String {
        let components_formatter = DateComponentsFormatter()
        components_formatter.allowedUnits = [.day, .hour, .minute]
        components_formatter.unitsStyle = .abbreviated
        components_formatter.zeroFormattingBehavior = .dropLeading
        let resultDays = components_formatter.string(from: duration)!
        return "\(resultDays)"
    }
    
    func formatIntervalWithSeconds(duration: TimeInterval) -> String {
        let components_formatter = DateComponentsFormatter()
        components_formatter.allowedUnits = [.day, .hour, .minute, .second]
        components_formatter.unitsStyle = .abbreviated
        components_formatter.zeroFormattingBehavior = .dropLeading
        let resultDays = components_formatter.string(from: duration)!
        return "\(resultDays)"
    }
}


