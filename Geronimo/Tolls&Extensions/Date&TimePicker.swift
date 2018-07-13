//
//  Date&TimePicker.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/24/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class DateTimePicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var date: Date?
    var time: Date?
    var count: Int?
    
    var choices: [Int] = Array(0...100)
    
    func showDatePicker(completion: @escaping (Bool)->Void){
        self.date = nil
        let alert = UIAlertController(title: "Select date", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        let datePicker = UIDatePicker(frame: CGRect(x: 10, y: 30, width: 250, height: 140))
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(8760 * 3600 * 100) // 100 years
        
        alert.view.addSubview(datePicker)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            completion(false)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let date = datePicker.date
            self.date = date
            if self.date != nil {
                completion(true)
            }
        }))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func showTimePicker(completion: @escaping (Bool)->Void){
        self.time = nil
        let alert = UIAlertController(title: "Select time", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        let timePicker = UIDatePicker(frame: CGRect(x: 40, y: 30, width: 200, height: 140))
        timePicker.datePickerMode = .time
       
        alert.view.addSubview(timePicker)
       
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            completion(false)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let time = timePicker.date
            self.time = time
            if self.time != nil {
                completion(true)
            }
        }))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func showCountPicker(completion: @escaping (Bool)->Void ){
        let alert = UIAlertController(title: "Repeat Times", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 80, y: 30, width: 100, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            self.count = nil
            completion(false)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let row = pickerFrame.selectedRow(inComponent: 0)
            self.count = self.choices[row]
            if self.count != nil{
                completion(true)
            }
        }))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Picker View methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(choices[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.count = choices[row]
    }
    
}
