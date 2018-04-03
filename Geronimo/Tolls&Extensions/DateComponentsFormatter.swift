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
            var str_month = String(month)
            var str_day = String(day)
            if(day<10){
                str_day.insert("0", at: str_day.startIndex)
            }
            if(month<10){
                str_month.insert("0", at: str_month.startIndex)
            }
            return "\(str_day).\(str_month).\(year)"
        }
        if let hour = date.hour, let minute = date.minute{
            var str_hour = String(hour)
            var str_min = String(minute)
            if(hour<10){
                str_hour.insert("0", at: str_hour.startIndex)
            }
            if(minute<10){
                str_min.insert("0", at: str_min.startIndex)
            }
            return "\(str_hour):\(str_min)"
        }
        return ""
    }
}

extension TimerSettingsTable{
    
    func formatDate(date: DateComponents) -> String{
        if let year = date.year, let month = date.month, let day = date.day{
            var str_month = String(month)
            var str_day = String(day)
            if(day<10){
                str_day.insert("0", at: str_day.startIndex)
            }
            if(month<10){
                str_month.insert("0", at: str_month.startIndex)
            }
            return "\(str_day).\(str_month).\(year)"
        }
        if let hour = date.hour, let minute = date.minute{
            var str_hour = String(hour)
            var str_min = String(minute)
            if(hour<10){
                str_hour.insert("0", at: str_hour.startIndex)
            }
            if(minute<10){
                str_min.insert("0", at: str_min.startIndex)
            }
            return "\(str_hour):\(str_min)"
        }
        return ""
    }
}

extension UpTimerDelegateDataSource{
    
    func formatDate(date: DateComponents) -> String{
        if let year = date.year, let month = date.month, let day = date.day{
            var str_month = String(month)
            var str_day = String(day)
            if(day<10){
                str_day.insert("0", at: str_day.startIndex)
            }
            if(month<10){
                str_month.insert("0", at: str_month.startIndex)
            }
            return "\(str_day).\(str_month).\(year)"
        }
        if let hour = date.hour, let minute = date.minute{
            var str_hour = String(hour)
            var str_min = String(minute)
            if(hour<10){
                str_hour.insert("0", at: str_hour.startIndex)
            }
            if(minute<10){
                str_min.insert("0", at: str_min.startIndex)
            }
            return "\(str_hour):\(str_min)"
        }
        return ""
    }
}
