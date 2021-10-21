//
//  TodoListContracts.swift
//  ToDoApp
//
//  Created by ulas on 18.10.2021.
//

import Foundation

protocol TodoListViewModelProtocol {
    var delegate: TodoListViewModelDelegate? { get set }
    func viewDidLoad()
    func didSelectRow(at indexPath: IndexPath)
    func saveTodo(title: String)
    func addTodoForTableView()
}

enum TodoListViewModelOutput {
    case showTodoList([TodoListPresentation])
}

enum TodoListViewRoute {
    case showTodoDetail(Todo)
}

protocol TodoListViewModelDelegate: AnyObject {
    func handleOutput(_ output: TodoListViewModelOutput)
    func navigateToRoute(to route: TodoListViewRoute)
}
