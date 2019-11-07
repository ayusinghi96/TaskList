//
//  UserProfileResponse.swift
//  TaskManager
//
//  Created by Ayush on 04/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

struct UserProfileResponse: Codable {

    let message: UserObj
    let status: Int
    let tasks: TaskCount

    enum CodingKeys: String, CodingKey {
        case message
        case status
        case tasks = "task_count"
    }
}

struct TaskCount: Codable {
    
    let taskCreated: Double
    let taskCancelled: Double
    let taskDone: Double
    
    enum CodingKeys: String, CodingKey {
        
        case taskCreated
        case taskCancelled
        case taskDone
    }
}

struct UserObj: Codable {

    let username: String
    let email: String

    enum CodingKeys: String, CodingKey {
        
        case username
        case email
    }
}
