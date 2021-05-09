//
//  CompletedTaskViewController.swift
//  TaskManager
//
//  Created by Ayush on 09/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class CompletedTaskViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var completedTaskTable: UITableView!

    // Variables
    var completedTasks = [TaskObj]()

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting up tableView Delegate and DataSource
        completedTaskTable.delegate = self
        completedTaskTable.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // Making API call to get tasks
        ApiClientTask.downloadTask(url: URL(string: ApiClientTask.UrlEndpoints.getCompletedTask.stringValue)!, completionHandler: handleResponse(bool:error:message:tasks:))
    }

    // MARK: Handlers
    // Handling API response
    func handleResponse(bool: Bool, error: Error?, message: String?, tasks: [TaskObj]?) {

        // If task data is returned
        if bool {

            // Safely guarding the nullable tasks
            guard let tasks = tasks else {
                return
            }

            // if the an empty task array is returned inform the user
//            if tasks.count == 0 {
//                
//                CommonAppFunction.showAlertDailog(view: self, title: "No Tasks", message: "You have not completed any task!")
//                
//            }

            // Inflating the completed task list with response list
            self.completedTasks = tasks
            // Reloading the tableView
            self.completedTaskTable.reloadData()
        } else {

            CommonAppFunction.showAlertDailog(view: self, title: "Failure", message: message!)
        }
    }
}

// Extension handling the tableView Delegates and DataSource
extension CompletedTaskViewController: UITableViewDelegate, UITableViewDataSource {

    // Setting up number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return completedTasks.count
    }

    // Setting up number of sections
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    // Inflating the data into the prototype cell and present the rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "taskHolder") as! TaskTableViewCell
        let currentTask = completedTasks[indexPath.row]

        cell.setCell(taskTitle: currentTask.title, taskDescrpition: currentTask.description, taskCreatedAt: currentTask.date)

        return cell
    }

    // Presenting taskDetailVC when user presses on a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let taskDetailVC = UIStoryboard(name: "TaskDetail", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController

        let currentTask = completedTasks[indexPath.row]
        taskDetailVC.task = currentTask

        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}

