//
//  Task.swift
//  todo
//
//  Created by Dimash Bekzhan on 6/28/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation

class Task {
    var task: String
    var date: Date
    var lifeCategory: String
    var isDone: Bool
    
    init(task: String, date: Date, lifeCategory: String, isDone: Bool = false) {
        self.task = task
        self.date = date
        self.lifeCategory = lifeCategory
        self.isDone = isDone
    }
}
