//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by ulas on 18.10.2021.
//

import Foundation
import UIKit

class TodoListViewModel: TodoListViewModelProtocol {
    weak var delegate: TodoListViewModelDelegate?

    private let service: CoreDataManagerProtocol!
    private var todoList = [Todo]()
    private let localNotificationManager = LocalNotificationManager()

    init(service: CoreDataManagerProtocol) {
        self.service = service
    }

    func viewDidLoad() {
        getTodoList()
    }

    func getTodoList() {
        let todoList = service.fetchTodoList()
        self.todoList = todoList
        self.delegate?.handleOutput(.showTodoList(todoList.map(TodoListPresentation.init)))
    }

    func didSelectRow(at indexPath: IndexPath) {
        let todo = todoList[indexPath.row]
        self.delegate?.navigateToRoute(to: .showTodoDetail(todo))
    }

    func saveTodo(title: String) {
        service.saveTodo(title: title)
    }

    func deleteTodo(with index: Int) {
        service.deleteTodo(todo: todoList[index])
    }

    func orderTodoListByDate(todoList: inout [TodoListPresentation]) {
        todoList.sort { $0.modifyDate > $1.modifyDate }
    }

    func searchMechanism(filteredList: inout [TodoListPresentation],
                         originalList: [TodoListPresentation],
                         searchText: String) {

        filteredList.removeAll()
        if searchText.count == 0 {
            filteredList = originalList
        } else {
            for todo in originalList {
                if todo.title.isMatching(with: searchText) {
                    filteredList.append(todo)
                }
            }
        }
    }

    func initializeNotification() {
        localNotificationManager.authorizeNotification()
    }
}
