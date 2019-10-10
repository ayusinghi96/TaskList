//
//  GetTaskResponse.swift
//  TaskManager
//
//  Created by Ayush on 01/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

struct GetTaskResponse: Codable{
    let task: [TaskObj]
    let status: Int
    
    enum CodingKeys: String, CodingKey{
        
        case task = "message"
        case status
        
    }
}

struct TaskObj: Codable{
    let id: String
    let title: String
    let description: String
    let username: String
    let reason: String
    let date: String
    var state: String

    
    enum CodingKeys: String, CodingKey{
        
        case id = "_id"
        case title
        case description
        case date = "created_on"
        case state
        case reason
        case username

    }
}
