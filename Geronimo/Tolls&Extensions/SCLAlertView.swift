//
//  SCLAlertView.swift
//  Geronimo
//
//  Created by Serg Liamthev on 4/15/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import SCLAlertView

extension SCLAlertView{
    func showErrorAlert(title: String, message: String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("OK") {
            print("OK button tapped")
        }
        alert.showError(title, subTitle: message) // Error
    }
}
