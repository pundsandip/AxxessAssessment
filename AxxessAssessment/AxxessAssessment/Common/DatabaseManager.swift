//
//  DatabaseManager.swift
//  AxxessAssessment
//
//  Created by Sandip Pund on 28/07/20.
//  Copyright © 2020 Sandip Pund. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class DatabaseManager {
    // Singleton instance
    static let sharedInstance: DatabaseManager = DatabaseManager()
    // Get the default Realm
    let realm = try! Realm()
    private init() { }
    
    func storeDataInDatabse(dataModel: [DataModel]) {
        deleteAllData()
        let taskList = TaskList()
        for data in dataModel {
            let taskModel = TaskModel()
            taskModel.id = data.id ?? ""
            taskModel.type = data.type ?? ""
            taskModel.date = data.date ?? ""
            taskModel.data = data.data ?? ""
            taskList.tasks.append(taskModel)
        }
        // Persist data to databse
        try! realm.write {
            realm.add(taskList)
        }
    }
    
    func fetchDataFromDatabse() -> Results<TaskList> {
        // Query Realm for all DataModel
        return realm.objects(TaskList.self)
    }
    
    func deleteAllData() {
        // delete all data
        try! realm.write({ () -> Void in
            realm.deleteAll()
        })
    }
    
}
