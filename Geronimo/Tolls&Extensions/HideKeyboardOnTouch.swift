//
//  HideKeyboardOnTouch.swift
//  Geronimo
//
//  Created by Serg Liamthev on 4/3/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
