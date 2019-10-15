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

        // Getting the date title and image to be displayed
        var data: (String, UIImage?) {
            switch state {
            case "done": return ("Completed on: \(date)", UIImage(named: "taskDoneIcon")!)
            case "cancel": return ("Deleted on: \(date)", UIImage(named: "taskNotDoneIcon", in: nil, compatibleWith: nil)!)
            case "created": return ("Created on: \(date)", nil)

            default:
                return ("No date available!", UIImage(named: "taskIcon", in: nil, compatibleWith: nil)!)
            }
        }

        // Setting up the cell elements with the data
        self.taskTitleLabel.text = title
        self.taskUpdateDateLabel.text = data.0
        self.taskStateImage.image = data.1

    }
}
