//
//  TaskDescriptionViewController.swift
//  TaskManager
//
//  Created by Ayush on 29/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class TaskDescriptionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var reasonStack: UIStackView!
    @IBOutlet weak var cancelReasonText: UITextView!
    
    var taskTitle: String!
    var taskDescription: String!
    var date: String!
    var taskState: String!
    var taskCancelReason: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if taskState != "cancelled"{
            reasonStack.isHidden = true
        }
        
        var dateString: String{
            switch taskState{
            case "cancelled": return "Cancelled on: "
            case "inProgress": return "Created on: "
            case "completed": return "Completed on: "
            default: return "No date available!"
            }
        }
        
        titleLabel.text = taskTitle
        dateLabel.text = (dateString + date)
        descriptionText.text = taskDescription
        
        if taskState == "cancelled"{
            guard let reason = taskCancelReason else{
                cancelReasonText.text = "No reason available!"
                return
            }
            cancelReasonText.text = reason
        }
        
    }
}
