//
//  TodoListPresentation.swift
//  ToDoApp
//
//  Created by ulas on 19.10.2021.
//

import Foundation

struct TodoListPresentation {
    let title: String
    let modifyDate: Date

    init(title: String, modifyDate: Date) {
        self.title = title
        self.modifyDate = modifyDate
    }

    init(todo: Todo) {
        self.init(title: todo.title!, modifyDate: todo.modifyTime!)
    }
}
