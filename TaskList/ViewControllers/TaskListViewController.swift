//
//  ViewController.swift
//  TaskList
//
//  Created by Ricardo Ruiz on 03/12/2019.
//  Copyright © 2019 Ricardo Ruiz. All rights reserved.
//

import UIKit

class TaskListViewController: UITableViewController, UISearchResultsUpdating {
    
    var taskFetcher = TaskFetcher()
    var addTaskButton = UIButton()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredTasks: [Task] = []
    
    // MARK: Viewcontroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredTasks = taskFetcher.tasks
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        searchController.searchBar.setShowsCancelButton(false, animated: false)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchBarStyle = .minimal
    }
    
    // MARK: SearchController delegate
    
    func filterContentForSearchText(_ searchText: String) {
        filteredTasks = taskFetcher.tasks.filter({ (searchedTask) -> Bool in
            return searchedTask.name.lowercased().contains(searchText.lowercased()) || searchText == ""
        })
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }

    // MARK: Tableview delegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        
        headerLabel.text = "Task List"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 36)
        headerLabel.textAlignment = .center
        headerView.backgroundColor = .white
        
        addTaskButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        
        headerView.addSubview(addTaskButton)
        headerView.addSubview(headerLabel)
        headerView.addSubview(searchController.searchBar)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false;
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false;
        
        addTaskButton.rightAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.rightAnchor, constant:  -20).isActive = true
        addTaskButton.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        addTaskButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addTaskButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addTaskButton.addTarget(self, action: #selector(AddTask), for: .touchUpInside)
        
        headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        searchController.searchBar.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.85).isActive = true
        searchController.searchBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        searchController.searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        searchController.searchBar.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Task List"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = filteredTasks[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as? TaskCell
        
        cell = TaskCell(id: task.id, name: task.name)
        cell!.taskName.addTarget(self, action: #selector(TextFieldDidChange(_:)), for: UIControl.Event.editingDidEnd)
        
        return cell!
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            taskFetcher.RemoveTask(id: filteredTasks[indexPath.row].id)
            updateSearchResults(for: searchController)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        show(CategoriesListViewController(selectedTask: filteredTasks[indexPath.row], taskListVC: self), sender: self)
    }
    
    // MARK: Selector
    
    @objc func AddTask()
    {
        taskFetcher.AddTask()
        updateSearchResults(for: searchController)
    }
    
    
    @objc func TextFieldDidChange(_ textField: UITextField)
    {
        taskFetcher.UpdateTaskName(name: textField.text ?? "", id: textField.tag)
        updateSearchResults(for: searchController)
    }
}
