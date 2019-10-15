//
//  RegisterResponse.swift
//  TaskManager
//
//  Created by Ayush on 23/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

// Structure of registerResponse JSON
struct RegisterResponse: Codable {
    let message: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case message
        case status
    }
}
