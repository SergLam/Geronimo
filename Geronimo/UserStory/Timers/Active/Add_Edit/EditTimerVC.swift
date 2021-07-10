//
//  EditTimerVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/21/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import SnapKit
import UIKit
import UserNotifications

final class EditTimerVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var navBarTitle: UINavigationItem!
    
    @IBOutlet private weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet private weak var timerTitle: UITextField!
    
    @IBOutlet private weak var timerNotes: UITextField!
    
    var timer: GeronimoTimer?
    
    // Settings Tables
    var settingsTable: TimerSettingsTable!
    
    convenience init(timer: GeronimoTimer) {
        self.init()
        self.timer = timer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTap()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        configureNavigationBar()
        configureTextFields()
        initSettingsTables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureNavigationBar(){
        guard let timer = self.timer else {
            return
        }
        if timer.isNew == true {
            self.navBarTitle.title = "Add timer"
        } else {
            self.navBarTitle.title = "Edit timer"
        }
    }
    
    func configureTextFields(){
        timerTitle.delegate = self
        timerTitle.text = timer?.name
        timerNotes.delegate = self
        timerNotes.text = timer?.timerDescription
        timerTitle.tag = 1
        timerNotes.tag = 2
    }
    
    func initSettingsTables(){
        // Get Timer type
        self.settingsTable = TimerSettingsTable(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: TimerSettingsTable().cellHeight * 3), style: UITableView.Style.grouped)
        self.contentView.addSubview(settingsTable)
        setTimerSettingsTableDataSource()
        settingsTable.reloadData()
        settingsTable.snp.makeConstraints{ make in
            make.right.equalTo(self.view).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.top.equalTo(timerNotes).offset(timerNotes.frame.height)
            make.height.equalTo(settingsTable.contentSize.height + 100)
        }
    }
    
    func setTimerSettingsTableDataSource(){
        let sectionHeaders = ["", "Repeats", "Begin", "End", "Worked Time"]
        let cellTitles = [["Type", "Period"], ["Infinetily", "Repeats"], ["Now", "Date", "Time"], ["Never", "Date", "Time"], ["Only worked time", "Begin", "End"] ]
        guard let timer = self.timer else {
            return
        }
        let cellValues = [ [timer.type, timer.period], [timer.isInfinetily, timer.repeats], [timer.isNow, timer.beginDate, timer.beginDate], [timer.isNever, timer.endDate, timer.endDate], [timer.isOnlyWorked, timer.beginWorkTime, timer.endWorkTime] ]
        settingsTable.setData(cellTitles: cellTitles, cellValues: cellValues, sectionHeaders: sectionHeaders, timer: timer)
    }
    
    @IBAction private func cancelBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func saveBarButton(_ sender: UIBarButtonItem) {
        if validateTextFields() {
            let validation_result = validateTimer()
            if validation_result.0 {
                // TODO: logic for new and not new timers
                // TODO: send notification from here (or cancel old notification and send new one)
                guard let timer = settingsTable?.timer else {
                    return
                }
                // Timer succesfully created
                if timer.id == -1 {
                    timer.isNew = false
                }
                if timer.isNow {
                    timer.beginDate = Date()
                }
                timer.name = self.timerTitle.text ?? ""
                timer.timerDescription = self.timerNotes.text ?? ""
                timer.timeToNextAlarm = timer.calculate_timeToNextAlarm(timer: timer)
                switch timer.isNew{
                case true:
                    timer.lastNotificationID = NotificationsManager.sharedInstance.randomString()
                    NotificationsManager.sharedInstance.sendNotification(timer: timer)
                case false:
                    if let notificationID = timer.lastNotificationID{
                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationID])
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
                        timer.lastNotificationID = NotificationsManager.sharedInstance.randomString()
                        NotificationsManager.sharedInstance.sendNotification(timer: timer)
                    }
                }
                let timer_realm = TimerRealm(timer: timer)
                DBManager.sharedInstance.addTimer(object: timer_realm)
                self.dismiss(animated: true, completion: nil)
                return
            } else {
                AlertPresenter.showErrorAlert(at: self, error: validation_result.1)
                return
            }
        } else {
            AlertPresenter.showErrorAlert(at: self, error: "Please, enter timer title.")
            return
        }
        
    }
    
    // MARK: Text Field delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 1:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 32
        case 2:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 64
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func validateTextFields() -> Bool{
        if let title = timerTitle.text{
            if title.isEmpty {
                return false
            } else{
                return true
            }
        }
        return false
    }
    
    func validateTimer() -> (Bool, String){
        guard let timer = self.settingsTable?.timer else{
            return (false, "Timer is nil")
        }
        // Check if begin time less than end time
        if timer.isNow == false && timer.isNever == false {
            // Check if it same day
            let day_begin = Calendar.current.component(.day, from: timer.beginDate)
            let day_end = Calendar.current.component(.day, from: timer.endDate)
            if day_begin == day_end {
                let hour_begin = Calendar.current.component(.hour, from: timer.beginDate)
                let hour_end = Calendar.current.component(.hour, from: timer.endDate)
                let min_begin = Calendar.current.component(.minute, from: timer.beginDate)
                let min_end = Calendar.current.component(.minute, from: timer.endDate)
                // Check if begin time greater than end
                if hour_begin < hour_end || min_begin < min_end {
                    return (false, "Begin time should be greater than end time")
                } else {
                    return (true, "All OK")
                }
            }
        }
        // Check "only worked time" - begin time less than end time
        if timer.isOnlyWorked == true {
            let hour_begin = Calendar.current.component(.hour, from: timer.beginDate)
            let hour_end = Calendar.current.component(.hour, from: timer.endDate)
            let min_begin = Calendar.current.component(.minute, from: timer.beginDate)
            let min_end = Calendar.current.component(.minute, from: timer.endDate)
            // Check if begin time greater than end
            if hour_begin < hour_end || min_begin < min_end {
                return (false, "Begin time should be greater than end time")
            } else {
                return (true, "All OK")
            }
        } else {
            return (true, "All OK")
        }
    }
    
}
