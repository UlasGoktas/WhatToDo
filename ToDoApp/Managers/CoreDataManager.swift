//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by ulas on 29.09.2021.
//

import UIKit
import CoreData

protocol CoreDataManagerProtocol {
    func getContext() -> NSManagedObjectContext
    func saveTodo(title: String)
    func updateTodo(with todoId: UUID, title: String, description: String?, completionDate: Date?)
    func fetchTodoList() -> [Todo]
}

class CoreDataManager: CoreDataManagerProtocol {

    func getContext() -> NSManagedObjectContext {
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        return appDelegate.persistentContainer.viewContext
    }

    // Save object into Core Data
    func saveTodo(title: String) {
        let context = getContext()
        let newTodo = Todo(context: context)

        newTodo.id = UUID()
        newTodo.title = title
        newTodo.modifyTime = Date()

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateTodo(with todoId: UUID, title: String, description: String?, completionDate: Date?) {
        let context = getContext()

        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let predicate = NSPredicate(format: "\(K.CoreData.forKeyId) == %@", todoId as CVarArg)
        fetchRequest.predicate = predicate

        do {
            let object = try context.fetch(fetchRequest)
            let objectUpdate = object.first

            objectUpdate?.title = title
            objectUpdate?.detail = description
            objectUpdate?.completionTime = completionDate
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

    func fetchTodoList() -> [Todo] {
        var todoList = [Todo]()
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()

        do {
            todoList = try getContext().fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }

        return todoList
    }
}
