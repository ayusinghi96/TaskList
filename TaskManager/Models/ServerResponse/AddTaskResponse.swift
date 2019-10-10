//
//  AddTaskResponse.swift
//  TaskManager
//
//  Created by Ayush on 01/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

//
struct AddTaskResponse: Codable{
    let task: TaskObj
    let status: Int
    
    enum CodingKeys: String, CodingKey{
        case task = "message"
        case status
    }
}

