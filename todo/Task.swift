//
//  Task.swift
//  todo
//
//  Created by Dimash Bekzhan on 6/28/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation

class Task {
    let task: String
    let date: String
    var isDone: Bool
    
    init(task: String, date: String, isDone: Bool = false) {
        self.task = task
        self.date = date
        self.isDone = isDone
    }
    
    
}
