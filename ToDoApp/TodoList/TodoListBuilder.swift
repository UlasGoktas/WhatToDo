//
//  TodoListBuilder.swift
//  ToDoApp
//
//  Created by ulas on 19.10.2021.
//

import UIKit

class TodoListBuilder {
    static func build() -> TodoListViewController {
        let storyboard = UIStoryboard(name: K.storyboardName, bundle: nil)
        let viewController = (storyboard.instantiateViewController(
            identifier: "TodoListViewController") as? TodoListViewController)!
        viewController.viewModel = TodoListViewModel(service: appContainer.service)
        return viewController
    }
}
