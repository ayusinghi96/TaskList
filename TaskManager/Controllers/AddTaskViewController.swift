//
//  AddTaskViewController.swift
//  TaskManager
//
//  Created by Ayush on 25/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {


    // MARK: Properties
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!

    // Variables
    var taskTitle: String = ""
    var taskDescription: String = ""

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizing the UITextView
        descriptionField.layer.borderWidth = 1
        descriptionField.layer.borderColor = UIColor.init(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1).cgColor
        descriptionField.layer.cornerRadius = 5

        // Customizing the UIButton
        addTaskButton.layer.cornerRadius = 5

        // Setting delegates for UITextView and UITextField
        titleField.delegate = self
        descriptionField.delegate = self


    }

    // Resigning the first responder status of textView on touching anywhere outside the textView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.descriptionField.resignFirstResponder()
    }


    // MARK: Actions
    @IBAction func AddTask(_ sender: Any) {

        // Disabling the UI elements
        // to stop user from creating multiple request and
        //change the text during the background processes
        
        changeUIElementEnableState(enable: false)

        // Making the API call if the user is title is mentioned
        if taskTitle != "" && titleField.text != nil {

            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let taskDateTime = df.string(from: Date())
            ApiClientTask.addTask(title: taskTitle, description: taskDescription, date: taskDateTime, completionHandler: addTaskHandler(bool:error:message:task:))

        } else {
            // Presenting an alert controller otherwise
            CommonAppFunction.showAlertDailog(view: self, title: "Required", message: "Title Field cannot be empty!")
        }

        // Enabling the UI Elements once appropriate task is completed
        changeUIElementEnableState(enable: true)
    }

    @IBAction func BackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: Helpers
    
    func changeUIElementEnableState(enable: Bool){
        titleField.isEnabled = enable
        descriptionField.isEditable = enable
        addTaskButton.isEnabled = enable
    }

    // MARK: Handlers

    func addTaskHandler(bool: Bool, error: Error?, message: String, task: TaskObj?) {
        if bool {
            guard let task = task else {
                return
            }

            AppDelegate.tasks.append(task)
            CommonAppFunction.showAlertDailog(view: self, title: "Success", message: message) {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            CommonAppFunction.showAlertDailog(view: self, title: "Failure", message: message)
        }
    }
}

// MARK: Extensions

// UITextField Delegates
extension AddTaskViewController: UITextFieldDelegate {

    // Resigning the first responder on Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Stopping the textView from clearing the already entered data
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return false
    }

    // Getting the title value whent the editting stops
    func textFieldDidEndEditing(_ textField: UITextField) {

        // Safely unwrapping the optional value of the task title field
        guard let title = textField.text else {
            return
        }

        taskTitle = title

    }
}

// UITextView Delegates
extension AddTaskViewController: UITextViewDelegate {

    // Removing the placeholder text when the user starts editing the textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Removing the placeholder iff it is currentlty equal to placeholder text
        // else leaving the textview as it is to let user entered text persist
        if textView.text! == "Enter the description of your task!" {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    // Checking to see if the user has entered any data
    func textViewDidEndEditing(_ textView: UITextView) {

        // If the user entered data is blank string then re-show the placeholder text
        // else unwrapping the text entered by the user
        if textView.text! == "" {
            textView.text = "Enter the description of your task!"
            textView.textColor = UIColor.init(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1)
        } else {
            taskDescription = textView.text!
        }

    }

}
