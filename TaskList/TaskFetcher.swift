//
//  TaskFetcher.swift
//  TaskList
//
//  Created by Ricardo Ruiz on 03/12/2019.
//  Copyright © 2019 Ricardo Ruiz. All rights reserved.
//

import Foundation

public class TaskFetcher {
    var tasks = [Task]()
    
    //    private let jsonPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Tasks.json")
    
    private let jsonPath = URL(fileURLWithPath: Bundle.main.path(forResource: "Tasks", ofType: "json")!)
    
    init() {
        LoadTasks()
    }
    
    func LoadTasks()
    {
        do {
            let data = try Data(contentsOf: jsonPath)
            tasks =  try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print ("No Task.json file found")
        }
    }
    
    func SaveTasks()
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try! encoder.encode(tasks)
        try! jsonData.write(to: jsonPath)
        
        //
        let convertedString = String(data: jsonData, encoding: String.Encoding.utf8)
        print(convertedString!)
    }
    
    func UpdateTaskName(name: String, id: Int)
    {
        let index = tasks.firstIndex { (task) -> Bool in
            task.id == id
        }
        
        tasks[index!].name = name
        SaveTasks()
    }
    
    public func AddTask()
    {
        let task = Task(id: UUID().hashValue, name: "New task", categories: [])
        tasks.append(task)
        SaveTasks()
    }
    
    public func RemoveTask(id : Int)
    {
        tasks.removeAll { (task) -> Bool in
            task.id == id
        }
        
        SaveTasks()
    }
    
    public func AddCategoryToTask(taskID: Int, categoryID: Int)
    {
        let index = tasks.firstIndex { (task) -> Bool in
            task.id == taskID
        }
        
        tasks[index!].categories.append(categoryID)
        
        SaveTasks()
    }
    
    public func RemoveCategoryFromTask(taskID: Int, categoryID: Int)
    {
        let index = tasks.firstIndex { (task) -> Bool in
            task.id == taskID
        }
        
        tasks[index!].categories.removeAll(where: { (category) -> Bool in
            category == categoryID
        })
            
        SaveTasks()
    }
}
