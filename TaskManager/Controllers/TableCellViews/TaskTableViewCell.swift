//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by Ayush on 23/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var taskTitileLabel: UILabel!
    @IBOutlet weak var taskCreatedAtLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!

    // MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Helpers
    // Setting cell for the current row
    func setCell(taskTitle: String, taskDescrpition: String, taskCreatedAt: String) {

        // Trimming date to desired length
        let index = taskCreatedAt.index(taskCreatedAt.startIndex, offsetBy: 10)
        let date = taskCreatedAt[..<index]

        self.taskTitileLabel.text = taskTitle
        self.taskDescriptionLabel.text = taskDescrpition
        self.taskCreatedAtLabel.text = String(date)
    }
}
