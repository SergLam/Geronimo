//
//  AlertPresenter.swift
//  Geronimo
//
//  Created by Serhii Liamtsev on 5/3/21.
//  Copyright © 2021 Serg Liamthev. All rights reserved.
//

import UIKit

final class AlertPresenter: NSObject {
    
    // MARK: - Ok alert
    static func showOkAlert(at vc: UIViewController, title: String) {
        
        executeOnMain {
            
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            
            let okBtnTitle: String = Localizable.ok(preferredLanguages: [UserDefaults.shared.selectedLocaleCode])
            let okAction = UIAlertAction(title: okBtnTitle, style: .default, handler: nil)
            alertController.addAction(okAction)
            vc.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Success message alert
    static func showSuccessAlert(at vc: UIViewController, message: String) {
        
        executeOnMain {
            
            let title: String = Localizable.success(preferredLanguages: [UserDefaults.shared.selectedLocaleCode])
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okBtnTitle: String = Localizable.ok(preferredLanguages: [UserDefaults.shared.selectedLocaleCode])
            let okAction = UIAlertAction(title: okBtnTitle, style: .default, handler: nil)
            alertController.addAction(okAction)
            vc.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Error alert for error object
    static func showErrorAlert(at vc: UIViewController, error: Error) {
        
        executeOnMain {
            AlertPresenter.showErrorAlertWithHandler(at: vc, errorMessgage: error.localizedDescription, handler: nil)
        }
    }
    
    // MARK: - Error alert with closure
    static func showErrorAlertWithHandler(at vc: UIViewController, errorMessgage: String, handler: TypeClosure<UIAlertAction>?) {
        
        executeOnMain {
            let alert = UIAlertController(title: Localizable.error(preferredLanguages: [UserDefaults.shared.selectedLocaleCode]), message: errorMessgage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: Localizable.ok(preferredLanguages: [UserDefaults.shared.selectedLocaleCode]), style: .default, handler: handler)
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }

}
