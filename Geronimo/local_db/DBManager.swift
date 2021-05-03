//
//  DBManager.swift
//  Geronimo
//
//  Created by Serg Liamthev on 4/15/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import RealmSwift
import UIKit

final class DBManager {
    
    private var database: Realm
    static let sharedInstance = DBManager()
    
    private init() {
        do {
            database = try Realm()
        } catch {
            preconditionFailure("Unable to create Realm instance - \(error.localizedDescription)")
        }
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
        
        let predicate: NSPredicate = NSPredicate(format: "lastNotificationID == %@", [id])
        let timers: Results<TimerRealm> = database.objects(TimerRealm.self).filter(predicate)
        return timers.first
    }
    
    func addTimer(object: TimerRealm) {
        do {
            try self.database.write {
                self.database.add(object, update: .modified)
                print("Add / update active timer")
            }
        } catch {
            LoggerService.logErrorWithTrace(error.localizedDescription)
        }
    }
    
    func deleteTimerById(timer_id: Int) {
        
        do {
            guard let timer = database.object(ofType: TimerRealm.self, forPrimaryKey: timer_id) else {
                return
            }
            try database.write {
                database.delete(timer)
                print("Delete timer by ID")
            }
            
        } catch {
            LoggerService.logErrorWithTrace(error.localizedDescription)
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
    
    func addEndedTimer(object: EndedTimerRealm) {
        
        do {
            try self.database.write {
                self.database.add(object, update: .modified)
                print("Add / update ended timer")
            }
        } catch {
            LoggerService.logErrorWithTrace(error.localizedDescription)
        }
        
    }
    
    func deleteEndedTimerById(timer_id: Int)   {
        
        do {
            guard let timer = database.object(ofType: EndedTimerRealm.self, forPrimaryKey: timer_id) else {
                return
            }
            try database.write {
                database.delete(timer)
                print("Delete timer by ID")
            }
            
        } catch {
            LoggerService.logErrorWithTrace(error.localizedDescription)
        }
        
    }
    
    func deleteAllDataFromDatabase()  {
        
        do {
            try database.write {
                database.deleteAll()
            }
        } catch {
            LoggerService.logErrorWithTrace(error.localizedDescription)
        }
        
    }
    
}
