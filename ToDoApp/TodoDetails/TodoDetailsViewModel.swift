//
//  TodoDetailViewModel.swift
//  ToDoApp
//
//  Created by ulas on 18.10.2021.
//

import Foundation
class TodoDetailsViewModel: TodoDetailsViewModelProtocol {
    weak var delegate: TodoDetailsViewModelDelegate?

//    private let service: CoreDataManagerProtocol!
    private var todo: Todo
    private let coreDataManager = CoreDataManager()

//    init(service: CoreDataManagerProtocol) {
//        self.service = service
//    }

    init(todo: Todo) {
        self.todo = todo
    }

    func viewDidLoad() {
        delegate?.showTodoDetails(TodoDetailsPresentation(todo: todo))
    }

    func updateTodo(with todoId: UUID, title: String, description: String?, completionDate: Date?) {
        coreDataManager.updateTodo(with: todoId, title: title, description: description, completionDate: completionDate)
    }
}
