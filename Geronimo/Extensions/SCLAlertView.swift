//
//  SCLAlertView.swift
//  Geronimo
//
//  Created by Serg Liamthev on 4/15/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import SCLAlertView
import UIKit

extension SCLAlertView{
    
    func showErrorAlert(title: String, message: String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular),
            kTextFont: UIFont(name: "HelveticaNeue", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular),
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold),
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("OK") {
            print("OK button tapped")
        }
        alert.showError(title, subTitle: message) // Error
    }
    
}
