//
//  TodoDetailBuilder.swift
//  ToDoApp
//
//  Created by ulas on 18.10.2021.
//

import Foundation

class TodoDetailsBuilder {
    static func build(with todo: Todo) -> TodoDetailsViewController {
        let detailsViewController = TodoDetailsViewController()
        detailsViewController.viewModel = TodoDetailsViewModel(todo: todo)
        return detailsViewController
    }
}
