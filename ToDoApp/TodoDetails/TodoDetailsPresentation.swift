//
//  TodoDetailsPresentation.swift
//  ToDoApp
//
//  Created by ulas on 20.10.2021.
//

import Foundation

struct TodoDetailsPresentation {
    let id: UUID
    let title: String
    let description: String?
    let completionDate: Date?

    init(id: UUID, title: String, description: String?, completionDate: Date?) {
        self.id = id
        self.title = title
        self.description = description
        self.completionDate = completionDate
    }

    init(todo: Todo) {
        self.init(id: todo.id!,
                  title: todo.title!,
                  description: todo.detail,
                  completionDate: todo.completionTime)
    }
}
