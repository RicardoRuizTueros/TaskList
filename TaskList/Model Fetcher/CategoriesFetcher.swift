//
//  CategoriesFetcher.swift
//  TaskList
//
//  Created by Ricardo Ruiz on 04/12/2019.
//  Copyright © 2019 Ricardo Ruiz. All rights reserved.
//

import Foundation

import Foundation

public class CategoriesFetcher {
    var categories = [Category]()
    
    // Path used for target physical devide, no default info
    private let jsonPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Categories.json")
    
    // Path used in simulator with json files provided
    //    private let jsonPath = URL(fileURLWithPath: Bundle.main.path(forResource: "Categories", ofType: "json")!)
    
    init() {
        LoadCategories()
    }
    
    func LoadCategories()
    {
        do {
            let data = try Data(contentsOf: jsonPath)
            categories =  try JSONDecoder().decode([Category].self, from: data)
        } catch {
            print ("No Categories.json file found")
        }
    }
    
    func SaveCategories()
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try! encoder.encode(categories)
        try! jsonData.write(to: jsonPath)
    }
    
    func AddCategory() {
        let category = Category(id: UUID().hashValue, name: "New category")
        categories.append(category)
        SaveCategories()
    }
    
    func RemoveCategory(id : Int)
    {
        categories.removeAll { (category) -> Bool in
            category.id == id
        }
        
        SaveCategories()
    }
    
    func UpdateCategoryName(name: String, id: Int)
    {
        let index = categories.firstIndex { (category) -> Bool in
            category.id == id
        }
        
        categories[index!].name = name
        SaveCategories()
    }
}
