//
//  MainVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

final class TimersVC: UIViewController {

    @IBOutlet private weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet private weak var tabSwitch: UISegmentedControl!
    
    @IBOutlet private weak var addBarButton: UIBarButtonItem!
    
    @IBOutlet private weak var contentView: UIView!
    
    var activeVC: ActiveTimersVC = ActiveTimersVC()
    
    var endedVC: EndedTimersVC = EndedTimersVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addChildViewControllerAsView(vc: activeVC)
        self.addChildViewControllerAsView(vc: endedVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.switchViewController(tabSwitch)
    }

    @IBAction func switchViewController(_ sender: UISegmentedControl) {
        let tab = sender.selectedSegmentIndex
        let vc_array = self.children
        
        for vc in vc_array{
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        
        switch tab {
        case 0:
            self.addChildViewControllerAsView(vc: activeVC)
        case 1:
            self.addChildViewControllerAsView(vc: endedVC)
        default:
           break
        }
    }
    
    func addChildViewControllerAsView(vc: UIViewController) {
        self.addChild(vc)
        vc.didMove(toParent: self)
        vc.view.frame = self.contentView.bounds
        self.contentView.addSubview(vc.view)
    }
    
    @IBAction private func openSettingVC(_ sender: UIBarButtonItem) {
        self.present(SettingsVC(), animated: true, completion: nil)
    }
    
    @IBAction private func addTimer(_ sender: UIBarButtonItem) {
        let editVC = EditTimerVC(timer: GeronimoTimer())
        self.present(editVC, animated: true, completion: nil)        
    }
    
    func configureSegmentedControl(){
        tabSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        tabSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
    }
    
}
