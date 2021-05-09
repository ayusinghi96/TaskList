//
//  LoginErrorResponse.swift
//  TaskManager
//
//  Created by Ayush on 01/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

// Structure of loginErrorResponse JSON
struct LoginErrorResponse: Codable {
    
    let message: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        
        case message = "token"
        case status
    }
}

