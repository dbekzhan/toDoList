//
//  TaskViewController.swift
//  todo
//
//  Created by Dimash Bekzhan on 6/28/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var textFieldTask: UITextField!
    
    @IBOutlet weak var datePickerDeadline: UIDatePicker!
    var newTask: Task! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func buttonAddTask(_ sender: UIButton) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let task = textFieldTask.text {
            let date = datePickerDeadline.date.description
            newTask = Task(task: task, date: date)
        }
    }
}
