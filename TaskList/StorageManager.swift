//
//  StorageManager.swift
//  TaskList
//
//  Created by Альбек Халапов on 28.09.2025.
//

import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [ToDoTask] {
        let fetchRequest = ToDoTask.fetchRequest()
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        } catch {
            print(error)
            return []
        }
    }
    
    func save(_ taskName: String) -> ToDoTask {
        let task = ToDoTask(context: context)
        task.title = taskName
        saveContext()
        return task
    }
    
}

