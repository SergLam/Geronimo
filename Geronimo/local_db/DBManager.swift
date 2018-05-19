//
//  DBManager.swift
//  Geronimo
//
//  Created by Serg Liamthev on 4/15/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager {
    private var database:Realm
    static let sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
    }
    
    // Methods for active timers
    
    func getTimers() -> Results<TimerRealm> {
        let results: Results<TimerRealm> = database.objects(TimerRealm.self)
        return results
    }
    
    func addTimer(object: TimerRealm)   {
        try! database.write {
            database.add(object, update: true)
            print("Added new object")
        }
    }
    
    func deleteTimer(object: TimerRealm)   {
        try! database.write {
            database.delete(object)
        }
    }
    
    // Methods for archived timers
    func getEndedTimers() -> Results<EndedTimerRealm> {
        let results: Results<EndedTimerRealm> = database.objects(EndedTimerRealm.self)
        return results
    }
    
    func addEndedTimer(object: EndedTimerRealm)   {
        try! database.write {
            database.add(object, update: true)
            print("Added new object")
        }
    }
    
    func deleteEndedTimer(object: EndedTimerRealm)   {
        try! database.write {
            database.delete(object)
        }
    }
    
    // ALARM! Drop DB method
    func deleteAllDataFromDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
    
}
