//
//  TaskModel.swift
//  AxxessAssessment
//
//  Created by Sandip Pund on 28/07/20.
//  Copyright © 2020 Sandip Pund. All rights reserved.
//

import Foundation
import RealmSwift

class TaskModel: Object {
    dynamic var id = ""
    dynamic var type = ""
    dynamic var date = ""
    dynamic var data = ""
}

class TaskList: Object {
    dynamic var createdAt = NSDate()
    dynamic let tasks = List<TaskModel>()
}
