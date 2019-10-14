//
//  CompletedTaskViewController.swift
//  TaskManager
//
//  Created by Ayush on 09/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class CompletedTaskViewController: UIViewController {

    @IBOutlet weak var completedTaskTable: UITableView!
    var completedTasks = [TaskObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completedTaskTable.delegate = self
        completedTaskTable.dataSource = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        ApiClientTask.getTask(url: ApiClientTask.Endpoints.getCompletedTask.url, completionHandler: handleResponse(bool:error:message:tasks:))
    }
    
    
    func handleResponse(bool: Bool, error: Error?, message: String?, tasks: [TaskObj]?){
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
                    let alertDailog = UIAlertController(title: "No Tasks", message: "You have not completed any task!", preferredStyle: .alert)
                    alertDailog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertDailog, animated: true, completion: nil)
                }
                
                // TODO: See the proper updating of the task array
                self.completedTasks = tasks
                self.completedTaskTable.reloadData()
            }else{
                let alertDailog = UIAlertController(title: "Failure", message: message!, preferredStyle: .alert)
                alertDailog.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertDailog, animated: true, completion: nil)
            }
        }
    }
}

extension CompletedTaskViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Inflate the data into the prototype cell and present the rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskHolder") as! TaskTableViewCell
        let currentTask = completedTasks[indexPath.row]
        
        cell.setCell(taskTitle: currentTask.title, taskDescrpition: currentTask.description, taskCreatedAt: currentTask.date)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let taskDetailVC = UIStoryboard(name: "TaskDetail", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController
        let currentTask = completedTasks[indexPath.row]
        
        taskDetailVC.taskDate = currentTask.date
        taskDetailVC.taskTitle = currentTask.title
        taskDetailVC.taskDescription = currentTask.description
        taskDetailVC.taskState = currentTask.state
        taskDetailVC.taskReason = currentTask.reason
        
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}

