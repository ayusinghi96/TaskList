//
//  LoginResponse.swift
//  TaskManager
//
//  Created by Ayush on 23/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

// Structure of loginResponse JSON
struct LoginResponse: Codable {
    let token: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case token
        case status
    }
}
