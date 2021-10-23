//
//  K.swift
//  ToDoApp
//
//  Created by ulas on 29.09.2021.
//

import Foundation

struct K {

    static let todoCellIdentifier = "TodoItemCell"
    static let storyboardName = "TodoList"

    struct NavigationBar {

        static let todoListTitle = "To-do List"
        static let detailsTitle = "Details"

    }

    struct SystemButtonName {

        static let addButton = "plus"
        static let orderByDateButton = "calendar.badge.clock"
    }
    struct BrandColors {

        static let button = "ButtonColor"
        static let background = "BackgroundColor"
        static let text = "TextColor"
    }

    struct Notification {

        static let imageName = "NotificationImage"
        static let identifier = "localNotification.date"

    }

    struct CoreData {

        static let persistentContainerName = "DataModel"
        static let entityName = "Todo"
        static let forKeyTitle = "title"
        static let forKeyDetail = "detail"
        static let forKeyCompletionTime = "completionTime"
        static let forKeyModifyTime = "modifyTime"
        static let forKeyId = "id"

    }
}
