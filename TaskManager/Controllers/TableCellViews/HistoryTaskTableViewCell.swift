//
//  HistoryTaskTableViewCell.swift
//  TaskManager
//
//  Created by Ayush on 25/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class HistoryTaskTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var taskUpdateDateLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskStateImage: UIImageView!

    // MARK: Overries
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Helpers
    // Setting up the cell in the task histroy tab
    func setCell(title: String, date: String, state: String) {

        // Trmming date to required size
        let formattedDate = date[..<(date.index(date.startIndex, offsetBy: 10))]

        // Getting the date title and image to be displayed
        var data: (String, UIImage?) {

            switch state {

            case "done": return ("Completed on: \(formattedDate)", UIImage(named: "taskDoneIcon")!)
            case "cancel": return ("Cancelled on: \(formattedDate)", UIImage(named: "taskNotDoneIcon", in: nil, compatibleWith: nil)!)
            case "created": return ("Created on: \(formattedDate)", nil)

            default:
                return ("No date available!", UIImage(named: "taskIcon", in: nil, compatibleWith: nil)!)
            }
        }

        // Populating UIElements
        self.taskTitleLabel.text = title
        self.taskUpdateDateLabel.text = data.0
        self.taskStateImage.image = data.1
    }
}
