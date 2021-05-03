//
//  TimerStatisticVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/22/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import Charts
import SnapKit
import UIKit

final class TimerStatisticVC: UIViewController {
    
    @IBOutlet private weak var timerTitle: UILabel!
    
    @IBOutlet private weak var timerDescription: UILabel!
    
    @IBOutlet private weak var succesLabel: UILabel!
    
    @IBOutlet private weak var failedLabel: UILabel!
    
    var activeTimer: GeronimoTimer?
    
    var succesPercent: Double = 0.0
    var succesCount: Int = 0
    
    var failPercent: Double = 0.0
    var failCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCircleView()
        updateTextLabels()
        // Do any additional setup after loading the view.
    }
    
    convenience init(timer: GeronimoTimer) {
        self.init()
        activeTimer = timer
        succesCount = timer.succesCount
        failCount = timer.failCount
        let count = timer.succesCount + timer.failCount
        // swiftlint:disable empty_count
        if count != 0 {
            succesPercent = Double(succesCount / (succesCount + failCount) * 100)
            failPercent = Double(failCount / (succesCount + failCount) * 100)
        }
        
    }
    
    func addCircleView() {
        
        // TODO: - Finishe pie chart
        // let chartView = PieChartView()
        
    }
    
    func updateTextLabels(){
        self.timerTitle.text = self.activeTimer?.name
        self.timerDescription.text = self.activeTimer?.timerDescription
        self.succesLabel.text = "Success: \(succesCount) (\(succesPercent)%)"
        self.failedLabel.text = "Failed: \(failCount) (\(failPercent)%)"
    }
    
    @IBAction func closeStatistic(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
