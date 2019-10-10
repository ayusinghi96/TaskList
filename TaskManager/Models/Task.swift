//
//  Task.swift
//  TaskManager
//
//  Created by Ayush on 26/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation


class Task{
    
    var title: String
    var description: String
    var date: String
    var state: String
    
    
    init(title: String, description: String, date: String, state: String) {
        self.title = title
        self.description = description
        self.date = date
        self.state = state
    }
    
}
