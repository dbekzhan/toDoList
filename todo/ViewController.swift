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

enum LifeCategories: String {
    case all, sport, study, food
}

class ViewController: UIViewController {

    // MARK: -Variables
    var tasks: [Task] = [Task(task: "do", date: Date(), lifeCategory: "sport")]
    var filteredTasks: [Task] = []
    var currentCategory: Categories = .all
    var currentLifeCategory: LifeCategories = .all
    var selectedIndexPath: IndexPath?
    
    // MARK: -UI Elements
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @IBOutlet weak var searchBarCategory: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segControlStatus: UISegmentedControl!
    @IBOutlet weak var segControlLife: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.searchBarCategory.delegate = self
        // filteredTasks = tasks
    }

    func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: -Actions
    @IBAction func segmentedControlDidSelectCategory(_ sender: UISegmentedControl) {
        guard let statusSectionTitle = segControlStatus.titleForSegment(at: segControlStatus.selectedSegmentIndex)?.lowercased(), let lifeSectionTitle = segControlLife.titleForSegment(at: segControlLife.selectedSegmentIndex)?.lowercased() else {
            return
        }
        
        print("\(statusSectionTitle), \(lifeSectionTitle)")
        
        
        guard let statusSection = Categories(rawValue: statusSectionTitle), let lifeSection = LifeCategories(rawValue: lifeSectionTitle) else { return }
        currentLifeCategory = lifeSection
        currentCategory = statusSection
        
        print("currents are \(currentLifeCategory, currentCategory)")
        
        guard let searchText = searchBarCategory.text else { return }
        
        filterContentForSearchText(searchText, scopes: (statusSection, lifeSection))
    }
    
    @IBAction func barButtonAdd(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "taskSegue", sender: self)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // UnwindSegue
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
        if sender.source is TaskViewController {
            guard let senderVC = sender.source as? TaskViewController else { return }
            guard let newTask = senderVC.newTask else { return }
            
            if let selectedIndexPath = selectedIndexPath {
                let oldTask = tasks[selectedIndexPath.row]
                oldTask.task = newTask.task
                oldTask.date = newTask.date
                oldTask.lifeCategory = newTask.lifeCategory
                // аннулировать
                self.selectedIndexPath = nil
            } else {
                tasks.append(newTask)
            }
            if let task = searchBarCategory.text {
                filterContentForSearchText(task, scopes: (currentCategory, currentLifeCategory))
            }
            
            tableView.reloadData()
        }
    }
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskSegue" {
            if let selectedIndexPath = selectedIndexPath {
                guard let destinationVC = segue.destination as? TaskViewController else { return }
                destinationVC.oldTask = tasks[selectedIndexPath.row]
            }
        }
    }
}

extension ViewController: TableViewCellDelegate {
    
    func tableViewCell(doubleTapActionDelegatedFrom cell: TaskTableViewCell) {
        selectedIndexPath = tableView.indexPath(for: cell)
        self.performSegue(withIdentifier: "taskSegue", sender: self)
    }
}
protocol TableViewCellDelegate {
    func tableViewCell(doubleTapActionDelegatedFrom cell: TaskTableViewCell)
}

//MARK: - Search Bar Extension
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let task = searchBar.text {
            filterContentForSearchText(task, scopes: (currentCategory, currentLifeCategory))
        }
    }
    
    var isSearchBarEmpty: Bool {
        return self.searchBarCategory.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String?, scopes: (Categories, LifeCategories)) {
    
        print(scopes)
        let (statusCategory, lifeCategory) = scopes
        var searchBasedFilteredTasks = tasks
        
        guard let searchText = searchText else { return }
        if !searchText.isEmpty {
            searchBasedFilteredTasks = tasks.filter { (task: Task) -> Bool in
                return task.task.lowercased().contains(searchText.lowercased())
            }
            print(searchBasedFilteredTasks)
            print("it's not empty")
        }
        
        let statusBasedFilteredTasks = searchBasedFilteredTasks.filter({ (task: Task) -> Bool in
            switch statusCategory {
            case .done:
                return task.isDone
            case .undone:
                print("undone")
                return !task.isDone
            case .all:
                return true
            }
        })
        
        print(statusBasedFilteredTasks)
        
        filteredTasks = statusBasedFilteredTasks.filter({ (task: Task) -> Bool in
            switch lifeCategory {
            case .all:
                return true
            case .food:
                return task.lifeCategory == "food"
            case .sport:
                return task.lifeCategory == "sport"
            case .study:
                return task.lifeCategory == "study"
            }
        })
        
        print(filteredTasks)
        self.tableView.reloadData()
    }
}

//MARK: - Table View Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentCategory == .all && currentLifeCategory == .all && isSearchBarEmpty {
            return tasks.count
        }
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        let task: Task!
        
        if isSearchBarEmpty && currentCategory == .all && currentLifeCategory == .all {
            task = tasks[indexPath.row]
        } else {
            task = filteredTasks[indexPath.row]
        }
        
        cell.taskRef = task
        cell.delegate = self
        cell.labelTask.text = task.task
        cell.labelDate.text = task.date.description
        cell.imageViewLifeCategory.image = UIImage(named: "\(task.lifeCategory)")
        cell.switchOutletState.isOn = task.isDone
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                cell.isSelected = false
            } else { cell.isSelected = true }
        }
    }
    
    // Edit rows
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    private func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if(editing && !tableView.isEditing){
            self.navigationItem.leftBarButtonItem?.title = "Done"
            tableView.setEditing(true, animated: true)
        }else{
            self.navigationItem.leftBarButtonItem?.title = "Edit"
            tableView.setEditing(false, animated: true)
        }
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

