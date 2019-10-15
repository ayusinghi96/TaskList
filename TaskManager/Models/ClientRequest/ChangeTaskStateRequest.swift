//
//  ChangeTaskStateRequest.swift
//  TaskManager
//
//  Created by Ayush on 02/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation


struct ChangeTaskStateToDone: Codable {
    let taskId: String

    enum CodingKeys: String, CodingKey {

        case taskId = "_id"
    }
}

struct ChangeTaskStateToCancel: Codable {
    let taskId: String
    let reason: String

    enum CodingKeys: String, CodingKey {
        case reason
        case taskId = "_id"
    }
}


