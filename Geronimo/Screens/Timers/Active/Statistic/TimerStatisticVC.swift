//
//  TimerStatisticVC.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/22/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit
import SnapKit
import RKPieChart

class TimerStatisticVC: UIViewController {

    @IBOutlet weak var timerTitle: UILabel!
    
    @IBOutlet weak var timerDescription: UILabel!
    
    @IBOutlet weak var succesLabel: UILabel!
    
    @IBOutlet weak var failedLabel: UILabel!
    
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
        self.activeTimer = timer
        self.succesCount = timer.succesCount
        self.failCount = timer.failCount
        self.succesPercent = Double(succesCount / (succesCount + failCount) * 100)
        self.failPercent = Double(failCount / (succesCount + failCount) * 100)
    }
    
    func addCircleView() {
        let succesItem: RKPieChartItem = RKPieChartItem(ratio: uint(succesPercent), color: .green, title: "1th Item ")
        let failItem: RKPieChartItem = RKPieChartItem(ratio: uint(failPercent), color: .orange, title: "1nd Item")
        let chartView = RKPieChartView(items: [succesItem, failItem], centerTitle: "")
        
        chartView.arcWidth = 120
        // Bug: if one percent equal to 0 or 100 - displaying not correctly
        if(succesPercent == 100){
            chartView.circleColor = .green
        } else if(failPercent == 100){
            chartView.circleColor = .orange
        }
        chartView.isTitleViewHidden = true
        chartView.isAnimationActivated = true
        self.view.addSubview(chartView)
        
        chartView.snp.makeConstraints{(make) -> Void in
            make.right.equalTo(self.view).offset(-20)
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.timerDescription.snp.bottom).offset(22)
            make.bottom.equalTo(self.succesLabel.snp.top).offset(-23)
            }
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
