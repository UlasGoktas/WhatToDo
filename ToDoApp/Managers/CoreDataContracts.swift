//
//  CoreDataContracts.swift
//  ToDoApp
//
//  Created by ulas on 22.10.2021.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func getContext() -> NSManagedObjectContext
    func saveTodo(title: String)
    func fetchTodoList() -> [Todo]
    func updateTodo(with todoId: UUID, title: String, description: String?, completionDate: Date?)
    func deleteTodo(todo: Todo)
}
