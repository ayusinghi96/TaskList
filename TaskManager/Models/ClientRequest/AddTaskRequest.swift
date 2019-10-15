//
//  AddTaskRequest.swift
//  TaskManager
//
//  Created by Ayush on 01/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

struct AddTaskRequest: Codable {

    let taskTitle: String
    let taskDescription: String
    let taskCreatedOn: String

    enum CodingKeys: String, CodingKey {

        case taskTitle = "title"
        case taskDescription = "description"
        case taskCreatedOn = "created_on"

    }
}
