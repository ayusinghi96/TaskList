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
    var historyTasks = [TaskObj]()

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting the table Delegate and DataSource
        taskHistoryTable.delegate = self
        taskHistoryTable.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // TODO: Make API Calls
        let days = 30

        // Making API call to get tasks
        ApiClientTask.getTask(url: createURL(days: days), completionHandler: handleResponse(bool:error:message:tasks:))
    }

    // MARK: Helpers

    // Create request URL
    func createURL(days: Int) -> URL {

        var url = ApiClientTask.UrlEndpoints.getTaskHistory.stringValue
        url = url+String(days)
        print(url)
        return URL(string: url)!
    }

    // MARK: Handlers
    // Handler function for filtering days
    func onDaysSelectedFromFilter(_ days: Int) -> Void {

        // Making API call to get tasks
        ApiClientTask.getTask(url: createURL(days: days), completionHandler: handleResponse(bool:error:message:tasks:))
    }

    // Handling API responses
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
//                // Alert Dailog to infrom the user
//                CommonAppFunction.showAlertDailog(view: self, title: "No Tasks", message: "You have no tasks older than 7 days!")
//
//            }

            // Inflating the historyTask list with response and reloading tableView
            self.historyTasks = tasks
            self.taskHistoryTable.reloadData()
        } else {

            // Notifying user of errors
            CommonAppFunction.showAlertDailog(view: self, title: "Failure", message: message!)
        }
    }

    // MARK: Navigation

    // Preparing the popUpVC before it appears
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popUpSegue" {

            let popUp = segue.destination as! DaysPopUpViewController
            popUp.onApplyFilter = onDaysSelectedFromFilter
        }
    }
}

// MARK: Extensions
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {

    // Getting the number of rows in each section in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return historyTasks.count
    }

    // Getting the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    // Setting up each table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableCell") as! HistoryTaskTableViewCell
        let currentTask = historyTasks[indexPath.row]

        cell.setCell(title: currentTask.title, date: currentTask.date, state: currentTask.state)

        return cell
    }

    // Setting up the viewController to be displayed on selecting a particular table row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let taskDetailVC = UIStoryboard(name: "TaskDetail", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController

        let currentTask = historyTasks[indexPath.row]
        taskDetailVC.task = currentTask

        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }

}
