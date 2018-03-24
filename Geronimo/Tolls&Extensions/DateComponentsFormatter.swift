//
//  DateComponentsFormatter.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/24/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func formatDate(date: DateComponents) -> String{
        if let year = date.year, let month = date.month, let day = date.day{
            if(day<10){
                return "0\(day).\(month).\(year)"
            }
            if(month<10){
                return "\(day).0\(month).\(year)"
            }
            return "\(day).\(month).\(year)"
        }
        if let hour = date.hour, let minute = date.minute{
            if(hour<10){
                return "0\(hour):\(minute)"
            }
            if(minute<10){
                return "\(hour):0\(minute)"
            }
            return "\(hour):\(minute)"
        }
        return ""
    }
}

extension TimerSettingsTable{
    
    func formatDate(date: DateComponents) -> String{
        if let year = date.year, let month = date.month, let day = date.day{
            if(day<10){
                return "0\(day).\(month).\(year)"
            }
            if(month<10){
                return "\(day).0\(month).\(year)"
            }
            return "\(day).\(month).\(year)"
        }
        if let hour = date.hour, let minute = date.minute{
            if(hour<10){
                return "0\(hour):\(minute)"
            }
            if(minute<10){
                return "\(hour):0\(minute)"
            }
            return "\(hour):\(minute)"
        }
        return ""
    }
}
