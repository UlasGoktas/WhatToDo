//
//  AppContainer.swift
//  ToDoApp
//
//  Created by ulas on 19.10.2021.
//

import Foundation

let appContainer = AppContainer()

class AppContainer {
    let service = CoreDataManager()
    let router = AppRouter()
}
