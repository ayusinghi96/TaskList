//
//  TaskDetailsViewController.swift
//  TaskManager
//
//  Created by Ayush on 30/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var reasonStack: UIStackView!

    // Variables
    var taskTitle: String!
    var taskDescription: String!
    var taskDate: String!
    var taskState: String!
    var taskReason: String?

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizing the TextView
        customizeTextView(descriptionTextView)
        customizeTextView(reasonTextView)

        // Check if reason stack needs to be hidden
        if taskState != "cancel" {
            reasonStack.isHidden = true
        } else {
            // Safely extracting the Cancellation Reason
            guard let reason = taskReason else {
                reasonTextView.text = "No reason to show!"
                return
            }
            reasonTextView.text = reason
        }

        // Processing the date title based on task state
        var dateString: String {
            switch taskState {
            case "cancel": return "Cancelled on: "
            case "created": return "Created on: "
            case "done": return "Completed on: "
            default: return "No date available!"
            }
        }

        // Setting the content on various elements
        titleLabel.text = taskTitle
        descriptionTextView.text = taskDescription
        dateLabel.text = dateString + taskDate

    }

    // MARK: Helpers
    // Function to customize TextViews
    func customizeTextView(_ textView: UITextView) {

        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.init(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1).cgColor
        textView.layer.cornerRadius = 5
    }
}
