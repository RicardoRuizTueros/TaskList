//
//  Category.swift
//  TaskList
//
//  Created by Ricardo Ruiz on 04/12/2019.
//  Copyright © 2019 Ricardo Ruiz. All rights reserved.
//

import Foundation

struct Category : Encodable, Decodable, Identifiable {
    var id : Int
    var name : String
}
