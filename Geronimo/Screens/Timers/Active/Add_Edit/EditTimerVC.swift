//
//  EditTimerVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/21/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import SnapKit
import SCLAlertView

class EditTimerVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var timerTitle: UITextField!
    
    @IBOutlet weak var timerNotes: UITextField!
    
    var timer: Timer?
    
    // Settings Tables
    var settingsTable: TimerSettingsTable?
    
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
        if (timer.isNew) {
            self.navBarTitle.title = "Add timer"
            self.saveBarButton.isEnabled = true
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
    
    func setTimer(timer: Timer){
        self.timer = timer
    }
    
    func initSettingsTables(){
        // Get Timer type
        self.settingsTable = TimerSettingsTable.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: TimerSettingsTable().cellHeight * 3), style: UITableViewStyle.grouped)
        setTimerSettingsTableDataSource()
        self.contentView.addSubview(settingsTable!)
        settingsTable!.reloadData()
        settingsTable!.snp_makeConstraints{(make) -> Void in
            make.right.equalTo(self.view).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.top.equalTo(timerNotes).offset(timerNotes.frame.height)
            make.height.equalTo(settingsTable!.contentSize.height+100)
        }
    }
    
    func setTimerSettingsTableDataSource(){
        let sectionHeaders = ["", "Repeats","Begin","End","Worked Time"]
        let cellTitles = [["Type", "Period"], ["Infinetily", "Repeats"], ["Now", "Date", "Time"], ["Never", "Date", "Time"], ["Only worked time", "Begin", "End"] ]
        guard let timer = self.timer else {
            return
        }
        let cellValues = [ [timer.type, timer.period], [timer.isInfinetily, timer.repeats], [timer.isNow, timer.beginDate, timer.beginTime], [timer.isNever, timer.endDate, timer.endTime], [timer.isOnlyWorked, timer.beginWorkTime, timer.endWorkTime] ]
        settingsTable!.setData(cellTitles: cellTitles, cellValues: cellValues, sectionHeaders: sectionHeaders, timer: timer, vc: self)
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBarButton(_ sender: UIBarButtonItem) {
        // TODO: function to save changes
        if (validateTextFields()){
            let validation_result = validateTimer()
            if(validation_result.0){
                // TODO: Save timer to Realm
                guard let timer = settingsTable?.timer! else {
                    return
                }
                // Timer succesfully created - not new
                timer.isNew = false
                timer.name = self.timerTitle.text!
                timer.timerDescription = self.timerNotes.text!
                let timer_realm = TimerRealm.init(timer: timer)
                DBManager.sharedInstance.addTimer(object: timer_realm)
                self.dismiss(animated: true, completion: nil)
                return
            } else {
                SCLAlertView().showErrorAlert(title: "Error", message: validation_result.1)
                return
            }
        } else {
            SCLAlertView().showErrorAlert(title: "Error", message: "Please, enter timer title.")
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
            if (title.isEmpty){
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
        let userCalendar = Calendar.current // user calendar
        if (timer.isNow == false && timer.isNever == false){
            // Check if it same day
            let day_begin = Calendar.current.component(.day, from: timer.beginDate)
            let day_end = Calendar.current.component(.day, from: timer.endDate)
            if (day_begin == day_end){
                let hour_begin = Calendar.current.component(.hour, from: timer.beginDate)
                let hour_end = Calendar.current.component(.hour, from: timer.endDate)
                let min_begin = Calendar.current.component(.minute, from: timer.beginDate)
                let min_end = Calendar.current.component(.minute, from: timer.endDate)
                // Check if begin time greater than end
                if (hour_begin < hour_end || min_begin < min_end){
                    return (false, "Begin time should be greater than end time")
                }
                else {
                    return (true, "All OK")
                }
            }
        }
        // Check "only worked time" - begin time less than end time
        if(timer.isOnlyWorked == true){
            let hour_begin = Calendar.current.component(.hour, from: timer.beginDate)
            let hour_end = Calendar.current.component(.hour, from: timer.endDate)
            let min_begin = Calendar.current.component(.minute, from: timer.beginDate)
            let min_end = Calendar.current.component(.minute, from: timer.endDate)
            // Check if begin time greater than end
            if (hour_begin < hour_end || min_begin < min_end){
                return (false, "Begin time should be greater than end time")
            }else {
                return (true, "All OK")
            }
        }
        return (false, "Timer is nil")
    }
    
}
