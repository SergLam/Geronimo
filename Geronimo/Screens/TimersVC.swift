//
//  MainVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/19/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class TimersVC: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tabSwitch: UISegmentedControl!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    @IBOutlet weak var contentView: UIView!
    
    var activeVC: ActiveTimersVC?
    
    var endedVC: EndedTimersVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationsManager.sharedInstance.requestUserPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.switchViewController(tabSwitch)
        UIApplication.statusBarBackgroundColor = UIColor.init(red: 16/255, green: 209/255, blue: 255/255, alpha: 1)
    }

    @IBAction func switchViewController(_ sender: UISegmentedControl) {
        let tab = sender.selectedSegmentIndex
        
        for v in contentView.subviews{
            v.removeFromSuperview()
        }
        
        switch tab {
        case 0:
            if let active = activeVC {
                self.changeVC(vc: active)
            } else {
                self.activeVC = ActiveTimersVC()
                self.changeVC(vc: self.activeVC!)
            }
        case 1:
            if let ended = endedVC {
                 self.changeVC(vc: ended)
            } else{
                 self.endedVC = EndedTimersVC()
                 self.changeVC(vc: self.endedVC!)
            }
        default:
           break
        }
    }
    
    func changeVC(vc: UIViewController) {
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        vc.view.frame = self.contentView.bounds
        self.contentView.addSubview(vc.view)
    }
    
    @IBAction func openSettingVC(_ sender: UIBarButtonItem) {
        self.present(SettingsVC(), animated: true, completion: nil)
    }
    
    @IBAction func addTimer(_ sender: UIBarButtonItem) {
        let editVC = EditTimerVC()
        editVC.setTimer(timer: Timer())
        self.present(editVC, animated: true, completion: nil)        
    }
    
    func configureSegmentedControl(){
        tabSwitch.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState.selected)
        tabSwitch.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState.normal)
    }
    
}
