//
//  TaskInProgressViewController.swift
//  TaskManager
//
//  Created by Ayush on 23/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class TaskInProgressViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Variables
    var reasonField: UITextField?
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiClientTask.getTask(url: ApiClientTask.Endpoints.getTask.url ,completionHandler: handleGetTask(bool:error:message:tasks:))
        
        // Helper to create the tasks
        //createTask()
        
        // Setting up the UITableView delegate and dataSource
        taskTable.delegate = self
        taskTable.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        taskTable.reloadData()
    }
    
    // MARK: Handlers
    
    // Handling the task fetch request from the user
    func handleGetTask(bool: Bool, error: Error?, message: String?, tasks: [TaskObj]?){
        
        // Switch back to main thread
        DispatchQueue.main.async {
            
            // If task data is returned
            if bool{
                
                // Safely guarding the nullable tasks
                guard let tasks = tasks else{
                    return
                }
                
                // if the an empty task array is returned inform the user
                if tasks.count == 0{
                    // Alert Dailog to infrom the user
                    let alertDailog = UIAlertController(title: "No Tasks", message: "You do not have any tasks to show!", preferredStyle: .alert)
                    alertDailog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertDailog, animated: true, completion: nil)
                }
                
                // TODO: See the proper updating of the task array
                AppDelegate.tasks = tasks
                self.taskTable.reloadData()
            }else{
                let alertDailog = UIAlertController(title: "Failure", message: message!, preferredStyle: .alert)
                alertDailog.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertDailog, animated: true, completion: nil)
            }
        }
    }
}

// MARK: Extensions

// UITableViewDelegate and UITableViewDataSource
extension TaskInProgressViewController: UITableViewDelegate, UITableViewDataSource{
    
    // Return the number of sections in teh table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return the number of rows in the the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.tasks.count
    }
    
    // Inflate the data into the prototype cell and present the rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskHolder") as! TaskTableViewCell
        let currentTask = AppDelegate.tasks[indexPath.row]
        
        cell.setCell(taskTitle: currentTask.title, taskDescrpition: currentTask.description, taskCreatedAt: currentTask.date)
        
        return cell
    }
    
    // Swipping function from LEFT -> RIGHT
    // Creating the success function
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let success = UIContextualAction.init(style: .normal, title: "Done") { (action, view, nil) in
            
            self.showAlertDailogForDone(title: "Sure?", message: "Is the task complete?", indexPath: indexPath)
            
        }
        
        // Configuring the success Action
        success.image = UIImage(named: "tickIcon")
        success.backgroundColor = UIColor.init(red: 0/255, green: 106/255, blue: 52/255, alpha: 1)
        
        // Initalizing the swipe on action
        let config = UISwipeActionsConfiguration(actions: [success])
        
        // Disabling the full right swipe
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
    
    // Swipping function from RIGHT -> LEFT
    // Creating the delete function
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction.init(style: .destructive, title: "Cancel") { (action, view, nil) in
            
            self.showAlertDailogForCancel(title: "Reason", message: "Add the reason for cancelling task!", indexPath: indexPath)
            
        }
        
        // Configuring the delete Action
        delete.image = UIImage(named: "crossIcon")
        
        // Initalizing the swipe on action
        let config = UISwipeActionsConfiguration(actions: [delete])
        
        // Disabling the full left swipe
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
    
    // Setting up the viewController to be displayed on selecting a particular table row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let taskDetailVC = storyboard?.instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController
        let currentTask = AppDelegate.tasks[indexPath.row]
        
        taskDetailVC.taskDate = currentTask.date
        taskDetailVC.taskTitle = currentTask.title
        taskDetailVC.taskDescription = currentTask.description
        taskDetailVC.taskState = currentTask.state
        taskDetailVC.taskReason = currentTask.reason
        
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
        
    }
    
    // MARK: Extention HELPER
    // Show Alert Dailog for confirmation
    func showAlertDailogForDone(title: String, message: String, indexPath: IndexPath){
        
        let alertDailog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertDailog.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            let url = ApiClientTask.Endpoints.successTask.url
            
            ApiClientTask.changeStateToDone(url: url, taskID: AppDelegate.tasks[indexPath.row].id, completionHandler: { (bool, error, message) in
                
                DispatchQueue.main.async {
                    if bool{
                        AppDelegate.tasks.remove(at: indexPath.row)
                        self.taskTable.reloadData()
                    }else{
                        let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            })
        }))
        
        // CANCEL Action
        alertDailog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Presenting the alert controller
        self.present(alertDailog, animated: true, completion: nil)
        
    }
    
    // Show Alert Dailog for getting a reason on 
    func showAlertDailogForCancel(title: String, message: String, indexPath: IndexPath){
        
        let alertDailog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertDailog.addTextField(configurationHandler: reasonTextField)
        
        alertDailog.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let url = ApiClientTask.Endpoints.cancelTask.url
            
            guard let reason = self.reasonField?.text else{
                return
            }
            
            if reason == ""{
                self.reasonField?.placeholder = "You must enter a reason!"
            }else{
                ApiClientTask.changeStateToCancel(url: url, taskID: AppDelegate.tasks[indexPath.row].id, reason: reason, completionHandler: { (bool, error, message) in
                    DispatchQueue.main.async {
                        if bool{
                            AppDelegate.tasks.remove(at: indexPath.row)
                            self.taskTable.reloadData()
                        }else{
                            let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            }
        }))
        
        // CANCEL Action
        alertDailog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Presenting the alert controller
        self.present(alertDailog, animated: true, completion: nil)
        
    }
    
    func reasonTextField(textField: UITextField!){
        reasonField = textField
        reasonField?.placeholder = "Enter the reason"
    }
}
