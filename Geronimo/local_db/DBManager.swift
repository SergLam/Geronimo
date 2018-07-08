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
    
    func getTimerByID(timerID: Int) -> TimerRealm? {
        let timer: TimerRealm? = database.object(ofType: TimerRealm.self, forPrimaryKey: timerID)
        return timer
    }
    
    func getTimerByNotificationID(id: String) -> TimerRealm? {
        let timers: Results<TimerRealm> = database.objects(TimerRealm.self).filter("lastNotificationID = "+id)
        return timers.first
    }
    
    func addTimer(object: TimerRealm)   {
            try! self.database.write {
                self.database.add(object, update: true)
                print("Add / update active timer")
            }
    }
    
    func deleteTimer(object: TimerRealm)   {
        try! database.write {
            database.delete(object)
        }
    }
    
    func deleteTimerById(timer: Timer){
        let timer: TimerRealm? = database.object(ofType: TimerRealm.self, forPrimaryKey: timer.id)
        if let object = timer{
            try! database.write {
                database.delete(object)
                print("Delete timer by ID")
            }
        }
    }
    
    // Methods for archived timers
    func getEndedTimers() -> Results<EndedTimerRealm> {
        let results: Results<EndedTimerRealm> = database.objects(EndedTimerRealm.self)
        return results
    }
    
    func getEndedTimerByID(timerID: Int) -> EndedTimerRealm? {
        let timer: EndedTimerRealm? = database.object(ofType: EndedTimerRealm.self, forPrimaryKey: timerID)
        return timer
    }
    
    func addEndedTimer(object: EndedTimerRealm)   {
            try! self.database.write {
                self.database.add(object, update: true)
                print("Add / update ended timer")
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
