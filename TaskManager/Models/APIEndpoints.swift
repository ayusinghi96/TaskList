//
//  APIEndpoints.swift
//  TaskManager
//
//  Created by Ayush on 09/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

class APIEndpoints{
    
    struct EndpointStringURL{
        
        static let baseUrl = "http://192.168.1.118:8000/"
        
        // List of AuthEndpoints
        static let register = "auth/user/register"
        static let login = "auth/user/login"
        static let logout = "auth/user/logout"
        
        // List of TaskEndpoints
        static let addTask = "task"
        static let getTask = "task"
        static let successTask = "task/done"
        static let getSuccessTask = "task/done"
        static let cancelTask = "task/cancel"
        static let getCancelledTask = "task/cancel"
        static let getTaskHistory = "task/history/days/"
        
        // List of profileEndpooints
        static let userProfile = "auth/user"
        
    }
}

