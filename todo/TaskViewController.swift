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
    @IBOutlet weak var segControlCategory: UISegmentedControl!
    
    var oldTask: Task? = nil
    var newTask: Task! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let oldTask = oldTask {
            setInitialOldValuesForComponents(fromTask: oldTask)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func buttonAddTask(_ sender: UIButton) {

    }
    
    private func setInitialOldValuesForComponents(fromTask task: Task) {
        textFieldTask.text = task.task
        datePickerDeadline.date = task.date
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let task = textFieldTask.text {
            let date = datePickerDeadline.date
            
            guard let lifeCategory = segControlCategory.titleForSegment(at: segControlCategory.selectedSegmentIndex)?.lowercased() else { return }
            newTask = Task(task: task, date: date, lifeCategory: lifeCategory)
        }
    }
}
