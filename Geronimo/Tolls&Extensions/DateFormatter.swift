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
}

extension TimerSettingsTable{
    
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
}

extension UpTimerDelegateDataSource{
    
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
}
