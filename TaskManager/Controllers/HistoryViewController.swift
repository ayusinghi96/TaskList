//
//  HistoryViewController.swift
//  TaskManager
//
//  Created by Ayush on 25/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var taskHistoryTable: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    
    // Variables
    // 3d Array of type TASK
    var tasks = [TaskObj]()
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setting the table delegates and datasource
        taskHistoryTable.delegate = self
        taskHistoryTable.dataSource = self
        
        ApiClientTask.getTask { (bool, error, message, tasks) in
            DispatchQueue.main.async {
                
                if bool{
                    guard let tasks = tasks else{
                        return
                    }
                    if tasks.count == 0{
                        let alertDailog = UIAlertController(title: "No Tasks", message: "You do not have any tasks to show!", preferredStyle: .alert)
                        alertDailog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertDailog, animated: true, completion: nil)
                    }
                    AppDelegate.tasks = tasks
                }else{
                    let alertDailog = UIAlertController(title: "Failure", message: message!, preferredStyle: .alert)
                    alertDailog.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertDailog, animated: true, completion: nil)
                }
            }
        }
        tasks = AppDelegate.tasks
        taskHistoryTable.reloadData()
    }
    
    @IBAction func filterContent(_ sender: Any) {
        filterButton.isEnabled = false
        
        let alertDailog = UIAlertController(title: "Days", message: "Add the number of days for which you want to see tasks!", preferredStyle: .alert)
        
        
    }
    
}

// MARK: Extensions
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    // Getting the number of rows in each section in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // Getting the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    // Setting up each table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableCell") as! HistoryTaskTableViewCell
        let currentTask = tasks[indexPath.row]

        cell.setCell(title: currentTask.title, date: currentTask.date, state: currentTask.state)
        
        return cell
    }
    
    // Setting the section header title and customizing the header
    // Providing the custom view to be displayed
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let view = UIView()
//        let sectionTitle = UILabel()
//
//        sectionTitle.frame = CGRect(x: 10, y: 5, width: 200, height: 35)
//        sectionTitle.textColor = UIColor.white
//        sectionTitle.font = UIFont(name: "Helvetica", size: 20)
//        sectionTitle.text = Section[section]
//
//        view.backgroundColor = UIColor.lightGray
//        view.addSubview(sectionTitle)
//
//        return view
//    }
    
    // Return the height of each section header
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 45
//    }
    
    // Setting up the viewController to be displayed on selecting a particular table row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let taskDetailVC = storyboard?.instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController
        let currentTask = tasks[indexPath.row]
        
        taskDetailVC.taskDate = currentTask.date
        taskDetailVC.taskTitle = currentTask.title
        taskDetailVC.taskDescription = currentTask.description
        taskDetailVC.taskState = currentTask.state
        taskDetailVC.taskReason = currentTask.reason
        
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
        
    }
    
}
