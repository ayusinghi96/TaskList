//
//  APIEndpoints.swift
//  TaskManager
//
//  Created by Ayush on 09/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

class APIEndpoints {

    struct EndpointStringURL {

        static let BaseUrl = "http://192.168.1.118:8000/"

        // List of AuthEndpoints
        static let Register = "auth/user/register"
        static let Login = "auth/user/login"
        static let Logout = "auth/user/logout"

        // List of TaskEndpoints
        static let AddTask = "task"
        static let GetTask = "task"
        static let SuccessTask = "task/done"
        static let GetSuccessTask = "task/done"
        static let CancelTask = "task/cancel"
        static let GetCancelledTask = "task/cancel"
        static let GetTaskHistory = "task/history/days/"

        // List of profileEndpooints
        static let UserProfile = "auth/user"
    }
}

