//
//  Taskcell.swift
//  TaskList
//
//  Created by Ricardo Ruiz on 03/12/2019.
//  Copyright © 2019 Ricardo Ruiz. All rights reserved.
//

import Foundation
import UIKit

class TaskCell : UITableViewCell {
    var taskImage = UIImageView()
    var taskName = UITextField()
    
    convenience init(id : Int, name : String)
    {
        self.init(style: .default, reuseIdentifier: "TaskCell")
        
        taskName.tag = id
        
        taskName.text = name
        taskImage.image = UIImage(systemName: "circle")
        
        contentView.addSubview(taskName)
        contentView.addSubview(taskImage)
        
        taskImage.translatesAutoresizingMaskIntoConstraints = false
        taskName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taskImage.heightAnchor.constraint(equalToConstant: 20),
            taskImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskImage.widthAnchor.constraint(equalToConstant: 20),

            taskName.leadingAnchor.constraint(equalTo: taskImage.trailingAnchor, constant: 20),
            taskName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
