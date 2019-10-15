//
//  LoginRequest.swift
//  TaskManager
//
//  Created by Ayush on 23/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

// Structure of loginRequest JSON
struct LoginRequest: Codable {
    let userName: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case password
    }
}
