//
//  SendFormVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/22/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

final class SendFormVC: UIViewController, UITextFieldDelegate {

    var screenName: String?
    
    @IBOutlet private weak var screenTitle: UINavigationItem!
    
    @IBOutlet private weak var titleTextField: UITextField!
    
    @IBOutlet private weak var msgTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenTitle.title = screenName
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func cancelBarBtnTap(_ sender: UIBarButtonItem) {
        hideKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func sendBarBtnTap(_ sender: UIBarButtonItem) {
        hideKeyboard()
        // TODO: send request to server
        self.dismiss(animated: true, completion: nil)
    }
    
    func hideKeyboard(){
        if titleTextField.isFirstResponder {
            titleTextField.resignFirstResponder()
        }
        if msgTextField.isFirstResponder {
            msgTextField.resignFirstResponder()
        }
    }

}
