//
//  AboutVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/22/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

final class AboutVC: UIViewController {

    @IBOutlet private weak var aboutText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeAboutVC(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
