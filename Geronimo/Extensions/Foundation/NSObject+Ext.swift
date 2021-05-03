//
//  NSObject+Ext.swift
//  Geronimo
//
//  Created by Serhii Liamtsev on 5/3/21.
//  Copyright © 2021 Serg Liamthev. All rights reserved.
//

import Foundation

extension NSObject {
    
    func executeOnMain(closure: @escaping VoidClosure) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    static func executeOnMain(closure: @escaping VoidClosure) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    static func getClassName(_ obj: AnyClass) -> String{
        return String(NSStringFromClass(obj.self).split(separator: ".").last ?? "")
    }
    
}
