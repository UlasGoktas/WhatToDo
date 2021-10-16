//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by ulas on 29.09.2021.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {

    private func getContext() -> NSManagedObjectContext {
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        return appDelegate.persistentContainer.viewContext
    }

    // Save object into Core Data
    func saveObject(title: String, detail: String?, completionTime: Date?) {
        let context = getContext()
        let newTodo = Todo(context: context)

        newTodo.id = UUID()
        newTodo.title = title
        newTodo.detail = detail
        newTodo.completionTime = completionTime
        newTodo.modifyTime = Date()

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateObject(todoId: UUID, title: String, detail: String?, completionTime: Date?) {
        let context = getContext()

        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let predicate = NSPredicate(format: "\(K.CoreData.forKeyId) == %@", todoId as CVarArg)
        fetchRequest.predicate = predicate

        do {
            let object = try context.fetch(fetchRequest)
            let objectUpdate = object.first

            objectUpdate?.title = title
            objectUpdate?.detail = detail
            objectUpdate?.completionTime = completionTime
            objectUpdate?.modifyTime = Date()

            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchObject(selectedScopeIndex: Int? = nil, searchText: String? = nil) -> [Todo] {
        var todoArray = [Todo]()

        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()

        if let index = selectedScopeIndex, let searchText = searchText {

            if index == K.SearchFilters.titleSearchIndex {

                let predicate = NSPredicate(
                    format: "\(K.SearchFilters.titleFilter) \(K.SearchFilters.filterRule)", searchText)
                fetchRequest.predicate = predicate

            } else if index == K.SearchFilters.timeSearchIndex {

                let sortDate = NSSortDescriptor(key: K.SearchFilters.modifyTimeFilter, ascending: false)
                fetchRequest.sortDescriptors = [sortDate]

            }

        }

        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            todoArray = fetchResult
        } catch {
            print(error.localizedDescription)
        }

        return todoArray
    }

}
