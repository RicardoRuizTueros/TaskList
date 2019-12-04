//
//  CategoriesList.swift
//  TaskList
//
//  Created by Ricardo Ruiz on 04/12/2019.
//  Copyright © 2019 Ricardo Ruiz. All rights reserved.
//

import UIKit

class CategoriesListViewController: UITableViewController {
    
    var addCategoryButton = UIButton()
    var backButton = UIButton()
    var task = Task(id: -1, name: "", categories: [])
    var categoriesFetcher = CategoriesFetcher()
    var taskFetcher = TaskFetcher()
    var taskListViewController : TaskListViewController?
    
    init(selectedTask : Task, taskListVC: TaskListViewController)
    {
        super.init(nibName: nil, bundle: nil)
        task = selectedTask
        taskListViewController = taskListVC
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        categoriesFetcher.LoadCategories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        taskListViewController?.taskFetcher.LoadTasks()
        taskListViewController?.updateSearchResults(for: taskListViewController!.searchController)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoriesFetcher.categories[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        let cellTextField = UITextField()
        
        if cell == nil {
            cell = UITableViewCell()
        }
        
        if task.categories.contains(category.id) {
            cell?.accessoryType = .checkmark
        }
        
        cellTextField.tag = category.id
        cellTextField.text = category.name
        cellTextField.addTarget(self, action: #selector(TextFieldDidChange(_:)), for: UIControl.Event.editingDidEnd)
        
        cell?.addSubview(cellTextField)
        
        cellTextField.translatesAutoresizingMaskIntoConstraints = false
        
        cellTextField.leadingAnchor.constraint(equalTo: cell!.leadingAnchor, constant: 20).isActive = true
        cellTextField.topAnchor.constraint(equalTo: cell!.topAnchor).isActive = true
        cellTextField.bottomAnchor.constraint(equalTo: cell!.bottomAnchor).isActive = true
        cellTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            categoriesFetcher.RemoveCategory(id: categoriesFetcher.categories[indexPath.row].id)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesFetcher.categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        if (tableView.visibleCells[indexPath.row].accessoryType == .none) {
            tableView.visibleCells[indexPath.row].accessoryType = .checkmark
                        
            taskFetcher.AddCategoryToTask(taskID: task.id, categoryID: categoriesFetcher.categories[indexPath.row].id)
        } else {
            tableView.visibleCells[indexPath.row].accessoryType = .none
            
            taskFetcher.RemoveCategoryFromTask(taskID: task.id, categoryID: categoriesFetcher.categories[indexPath.row].id)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        
        headerLabel.text = "Categories List"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headerLabel.textAlignment = .center
        headerView.backgroundColor = .white
        
        addCategoryButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        
        headerView.addSubview(addCategoryButton)
        headerView.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false;
        
        addCategoryButton.rightAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.rightAnchor, constant:  -20).isActive = true
        addCategoryButton.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        addCategoryButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addCategoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addCategoryButton.addTarget(self, action: #selector(AddCategory), for: .touchUpInside)
        
        headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Task List"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    @objc func AddCategory()
    {
        categoriesFetcher.AddCategory()
        tableView.reloadData()
    }
    
    @objc func TextFieldDidChange(_ textField: UITextField)
    {
        categoriesFetcher.UpdateCategoryName(name: textField.text ?? "", id: textField.tag)
        tableView.reloadData()
    }
}
