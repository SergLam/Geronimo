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
    
    var succesPercent: Int = 76
    var succesCount: Int = 10
    
    var failPercent: Int = 24
    var failCount: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCircleView()
        updateTextLabels()
        // Do any additional setup after loading the view.
    }
    
    func addCircleView() {
        let succesItem: RKPieChartItem = RKPieChartItem(ratio: uint(succesPercent), color: .green, title: "1th Item ")
        let failItem: RKPieChartItem = RKPieChartItem(ratio: uint(failPercent), color: .orange, title: "1nd Item")
        let chartView = RKPieChartView(items: [succesItem, failItem], centerTitle: "")
        
        chartView.arcWidth = 120
        chartView.circleColor = .green
        chartView.isTitleViewHidden = true
        chartView.isAnimationActivated = true
        self.view.addSubview(chartView)
        
        chartView.snp.makeConstraints{(make) -> Void in
            make.right.equalTo(self.view).offset(-20)
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.timerDescription.snp_bottom).offset(22)
            make.bottom.equalTo(self.succesLabel.snp_top).offset(-23)
            }
        
    }
    
    func updateTextLabels(){
        self.succesLabel.text = "Success: \(succesCount) (\(succesPercent)%)"
        self.failedLabel.text = "Failed: \(failCount) (\(failPercent)%)"
    }
    
    
    @IBAction func closeStatistic(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
