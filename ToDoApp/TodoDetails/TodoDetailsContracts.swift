//
//  TodoDetailsContracts.swift
//  ToDoApp
//
//  Created by ulas on 18.10.2021.
//

import Foundation

protocol TodoDetailsViewModelProtocol {
    var delegate: TodoDetailsViewModelDelegate? { get set }
    func viewDidLoad()
    func updateTodo(with todoId: UUID, title: String, description: String?, completionDate: Date?)
}

protocol TodoDetailsViewModelDelegate: AnyObject {
    func showTodoDetails(_ todo: TodoDetailsPresentation)
}
