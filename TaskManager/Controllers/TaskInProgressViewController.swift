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

    // Variables
    var reasonField: UITextField?

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting up the UITableView delegate and dataSource
        taskTable.delegate = self
        taskTable.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // Making API call to get on going tasks
        ApiClientTask.downloadTask(url: URL(string: ApiClientTask.UrlEndpoints.getTask.stringValue)!, completionHandler: handleGetTask(bool:error:message:tasks:))

    }

    // MARK: Handlers

    // Handling the response
    func handleGetTask(bool: Bool, error: Error?, message: String?, tasks: [TaskObj]?) {

        // If task data is returned
        if bool {

            // Safely extracting tasks
            guard let tasks = tasks else {
                return
            }

            // if the an empty task array is returned inform the user
//            if tasks.count == 0 {
//                // Alert Dailog to infrom the user
//                CommonAppFunction.showAlertDailog(view: self, title: "No Tasks", message: "You do not have any tasks to show!")
//            }

            // Setting the tasks list and reloading table
            AppDelegate.tasks = tasks
            self.taskTable.reloadData()
        } else {

            // Notifying user of errors
            CommonAppFunction.showAlertDailog(view: self, title: "Failure", message: message!)
        }

    }
}

// MARK: Extensions

// UITableViewDelegate and UITableViewDataSource
extension TaskInProgressViewController: UITableViewDelegate, UITableViewDataSource {

    // Returning number of sections in the table
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    // Returning number of rows in the the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return AppDelegate.tasks.count
    }

    // Inflating data into the prototype cell and present the rows
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
        success.backgroundColor = UIColor.init(red: 0 / 255, green: 106 / 255, blue: 52 / 255, alpha: 1)

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

        let taskDetailVC = UIStoryboard(name: "TaskDetail", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController

        let currentTask = AppDelegate.tasks[indexPath.row]
        taskDetailVC.task = currentTask

        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }

    // MARK: Extention Helpers
    // Alert Dailog for confirmation
    func showAlertDailogForDone(title: String, message: String, indexPath: IndexPath) {

        CommonAppFunction.showAlertDailog(view: self, title: title, message: message) { (bool) in

            if bool {

                // Creating URL and body of the request
                let url = URL(string: ApiClientTask.UrlEndpoints.successTask.stringValue)!
                let body = ChangeTaskStateToDone(taskId: AppDelegate.tasks[indexPath.row].id)

                // Making API call to complete task
                ApiClientTask.changeTaskState(url: url, body: body, completionHandler: { (bool, error, message) in

                    if bool {

                        AppDelegate.tasks.remove(at: indexPath.row)
                        self.taskTable.reloadData()
                    } else {

                        // Notifying user of errors
                        CommonAppFunction.showAlertDailog(view: self, title: "Failure", message: message)
                    }
                })
            }
        }
    }

    // Alert Dailog for getting a reason and confirmation
    func showAlertDailogForCancel(title: String, message: String, indexPath: IndexPath) {

        let alertDailog = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Adding textField for reason
        alertDailog.addTextField(configurationHandler: reasonTextField)

        // OK Action
        alertDailog.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in

            guard let reason = self.reasonField?.text else {
                return
            }

            let url = URL(string: ApiClientTask.UrlEndpoints.cancelTask.stringValue)
            let body = ChangeTaskStateToCancel(taskId: AppDelegate.tasks[indexPath.row].id, reason: reason)

            // Making API call to cancel task
            ApiClientTask.changeTaskState(url: url!, body: body, completionHandler: { (bool, error, message) in

                if bool {

                    AppDelegate.tasks.remove(at: indexPath.row)
                    self.taskTable.reloadData()
                } else {

                    let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }))

        // CANCEL Action
        alertDailog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Presenting the alert controller
        self.present(alertDailog, animated: true, completion: nil)
    }

    // Prototype TextField for alertDailog
    func reasonTextField(textField: UITextField!) {

        reasonField = textField
        reasonField?.placeholder = "Enter the reason"
        reasonField?.borderStyle = .roundedRect
    }
}
