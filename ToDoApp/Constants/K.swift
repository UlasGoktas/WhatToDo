//
//  K.swift
//  ToDoApp
//
//  Created by ulas on 29.09.2021.
//

import Foundation

struct K {
    
    static let appName = "✔️WhatToDo"
    static let todoCellIdentifier = "ToDoItemCell"
    static let detailSegue = "goToDetails"
    
    struct SearchBar {
        
        static let scopeButtonTitle = "Title"
        static let scopeButtonModifyTime = "Modify Time"
        
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
        
        struct SearchFilters {
            //[c] means case insensitive
            static let filterRule = "contains[c] %@"
            static let titleFilter = "title"
            static let modifyTimeFilter = "modifyTime"
            static let titleSearchIndex = 0
            static let timeSearchIndex = 1
        }
    }
    
}
