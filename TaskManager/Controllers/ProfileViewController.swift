//
//  ProfileViewController.swift
//  TaskManager
//
//  Created by Ayush on 25/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit
import Charts

class ProfileViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var taskHandledLabel: UILabel!
    @IBOutlet weak var taskPieChart: PieChartView!
    
    // Variables
    var createdTask = PieChartDataEntry(value: 0)
    var cancelledTask = PieChartDataEntry(value: 0)
    var completedTask = PieChartDataEntry(value: 0)
    
    var numberOfDataEntries: [PieChartDataEntry] = []

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Making API call
        ApiClientProfile.getUserProfile { (bool, error, message, user, tasks) in

            // Setting up UIElements if user is returned
            if bool {

                guard let user = user else {
                    self.userNameLabel.text = "Current User"
                    self.userEmailLabel.text = "User's current email"
                    return
                }

                self.userNameLabel.text = user.username
                self.userEmailLabel.text = user.email
                self.taskHandledLabel.text = String(tasks)
            }
        }
        
//        taskPieChart.chartDescription?.text = "Tasks Handled"
//        taskPieChart.chartDescription?.font = NSUIFont(name: "Arial", size: 17)!
        
        createdTask.value = 12
        createdTask.label = "ON"
        cancelledTask.value = 10
        cancelledTask.label = "CANCEL"
        completedTask.value = 23
        completedTask.label = "DONE"
        
        
        numberOfDataEntries = [createdTask, cancelledTask, completedTask]
        chartDataSet()
        
    }

    // MARK: Actions

    // Dismissing on pressing backButton
    @IBAction func backPressed(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helpers
    
    func chartDataSet(){
        
        let chartDataList = PieChartDataSet(values: numberOfDataEntries, label: nil)
        
        let chartData = PieChartData(dataSet: chartDataList)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        chartData.setValueFormatter(formatter)
        
        let colors = [UIColor(named: "Pi1"), UIColor(named: "Pi2"), UIColor(named: "Pi3")]
        chartDataList.colors = colors as! [NSUIColor]
        
        taskPieChart.data = chartData
    }
}
