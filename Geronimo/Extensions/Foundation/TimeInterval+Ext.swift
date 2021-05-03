//
//  TimeInterval+Ext.swift
//  Geronimo
//
//  Created by Serhii Liamtsev on 5/3/21.
//  Copyright © 2021 Serg Liamthev. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    static var minute: TimeInterval {
        return 60.0
    }
    
    static var hour: TimeInterval {
        return 3600.0
    }
    
    static var day: TimeInterval {
        return hour * 24
    }
    
    static var week: TimeInterval {
        return day * 7
    }
    
    static var month: TimeInterval {
        return day * 30
    }
    
    static var year: TimeInterval {
        return day * 365
    }
    
}
