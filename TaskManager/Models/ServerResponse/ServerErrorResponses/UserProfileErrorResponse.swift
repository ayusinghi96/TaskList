//
//  UserProfileErrorResponse.swift
//  TaskManager
//
//  Created by Ayush on 04/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

struct UserProfileErrorResponse: Codable {

    let message: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        
        case message
        case status
    }
}
