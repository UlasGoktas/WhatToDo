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
}
