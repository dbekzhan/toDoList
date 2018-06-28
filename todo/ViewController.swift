//
//  ViewController.swift
//  todo
//
//  Created by Dimash Bekzhan on 6/28/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

enum Categories: String {
    case all, done, undone
}

class ViewController: UIViewController {

    var tasks: [Task] = [Task(task:"do", date:"bla-bla")]
    var filteredTasks: [Task] = []
    var currentCategory: Categories = .all
    
    @IBOutlet weak var searchBarCategory: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchBarCategory.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: - Actions
    @IBAction func segmentedControlDidSelectCategory(_ sender: UISegmentedControl) {
        if let sectionTitle = sender.titleForSegment(at: sender.selectedSegmentIndex)?.lowercased() {
            if let category = Categories(rawValue: sectionTitle) {
                currentCategory = category
                filterContentForSearchText(self.searchBarCategory.text, scope: currentCategory)
            }
        }
    }
    
    @IBAction func barButtonAdd(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "taskSegue", sender: self)
    }
    
    @IBAction func barButtonEdit(_ sender: UIBarButtonItem) {
        
    }
    // UnwindSegue
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
        if sender.source is TaskViewController {
            if let senderVC = sender.source as? TaskViewController {
                tasks.append(senderVC.newTask)
            }
            tableView.reloadData()
        }
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let task = searchBar.text {
            filterContentForSearchText(task, scope: currentCategory)
        }
    }
    
    var isSearchBarEmpty: Bool {
        return self.searchBarCategory.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String?, scope: Categories) {
    
        var searchBasedFilteredTasks = tasks
        
        guard let searchText = searchText else { return }
        if !searchText.isEmpty {
            searchBasedFilteredTasks = tasks.filter { (task: Task) -> Bool in
                return task.task.lowercased().contains(searchText.lowercased())
            }
            print("it's not empty")
        }
        
        filteredTasks = searchBasedFilteredTasks.filter({ (task: Task) -> Bool in
            switch scope {
            case .done:
                return task.isDone
            case .undone:
                print("undone")
                return !task.isDone
            case .all:
                return true
            }
        })
        print(filteredTasks)
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentCategory == .all {
            return tasks.count
        }
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        let task = currentCategory == .all ? tasks[indexPath.row] : filteredTasks[indexPath.row]
        cell.labelTask.text = task.task
        cell.labelDate.text = task.date
        cell.switchOutletState.isOn = task.isDone
        return cell
    }
    
    // Edit rows
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(movedObject, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(tasks)")
        self.tableView.reloadData()
    }
}

