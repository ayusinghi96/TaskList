//
//  TaskHistoryResponse.swift
//  TaskManager
//
//  Created by Ayush on 18/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation


struct TaskHistoryResponse: Codable {
    
    let count: Int
    let nextURL: String?
    let previousURL: String?
    let tasks: [TaskObj]
    
    enum CodingKeys: String, CodingKey {
        
        case count
        case nextURL = "next"
        case previousURL = "previous"
        case tasks = "results"
    }
}


struct TaskHistoryErrorResponse: Codable {
    
    let message: String
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        
        case message
        case status
    }
}

