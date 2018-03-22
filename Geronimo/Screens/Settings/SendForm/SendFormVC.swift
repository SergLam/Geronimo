//
//  SendFormVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/22/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class SendFormVC: UIViewController, UITextFieldDelegate {

    var screenName: String?
    
    @IBOutlet weak var screenTitle: UINavigationItem!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var msgTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenTitle.title = screenName
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBarBtnTap(_ sender: UIBarButtonItem) {
        hideKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendBarBtnTap(_ sender: UIBarButtonItem) {
        hideKeyboard()
        // TODO: send request to server
        self.dismiss(animated: true, completion: nil)
    }
    
    func hideKeyboard(){
        if (titleTextField.isFirstResponder){
            titleTextField.resignFirstResponder()
        }
        if(msgTextField.isFirstResponder){
            msgTextField.resignFirstResponder()
        }
    }
    

}
