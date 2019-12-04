//
//  Task.swift
//  TaskList
//
//  Created by Ricardo Ruiz on 03/12/2019.
//  Copyright © 2019 Ricardo Ruiz. All rights reserved.
//

import Foundation

struct Task : Encodable, Decodable, Identifiable {
    var id  : Int
    var name : String
    var categories : [Int]
}
