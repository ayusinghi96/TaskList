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
    var task: TaskObj?

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizing the TextView
        customizeTextView(descriptionTextView)
        customizeTextView(reasonTextView)

        // Checking if reason stack needs to be hidden
        if task?.state != "cancel" {

            reasonStack.isHidden = true
        } else {

            // Safely extracting the Cancellation Reason
            guard let reason = task?.reason else {

                reasonTextView.text = "No reason to show!"
                return
            }

            // Populating the reason text view
            reasonTextView.text = reason
        }

        // Processing the date title based on task state
        var dateString: String {

            switch task?.state {

            case "cancel": return "Cancelled on: "
            case "created": return "Created on: "
            case "done": return "Completed on: "
            default: return "No date available!"
            }
        }

        // Populating different UIElements
        titleLabel.text = task?.title
        descriptionTextView.text = task?.description

        // Safely extracting the task dateTime
        guard let date = task?.date else {
            return
        }

        // Trimming dateTime to required size
        let formattedDate = date[..<(date.index(date.startIndex, offsetBy: 10))]

        // Populating dateLable element
        dateLabel.text = dateString + formattedDate

    }

    // MARK: Helpers

    // Function to customize TextViews
    func customizeTextView(_ textView: UITextView) {

        // Customizing the textview
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.init(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1).cgColor
        textView.layer.cornerRadius = 5
    }
}
