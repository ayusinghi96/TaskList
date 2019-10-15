//
//  GetTaskErrorResponse.swift
//  TaskManager
//
//  Created by Ayush on 02/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

struct GetTaskErrorResponse: Codable {
    let message: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case message
        case status
    }
}
