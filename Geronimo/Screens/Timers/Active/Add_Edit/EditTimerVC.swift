//
//  EditTimerVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/21/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import SnapKit

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
            self.saveBarButton.isEnabled = false
        } else {
            self.navBarTitle.title = "Edit timer"
        }
    }
    
    func configureTextFields(){
        timerTitle.delegate = self
        timerNotes.delegate = self
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
        self.dismiss(animated: true, completion: nil)
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
        if let text = textField.text {
            if(text.isEmpty){
                textField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 5, revert: true)
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
}
