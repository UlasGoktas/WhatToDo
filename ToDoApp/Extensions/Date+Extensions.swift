//
//  Date+Extensions.swift
//  ToDoApp
//
//  Created by ulas on 16.10.2021.
//

import Foundation

extension Date {
    func timeToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let formattedString = formatter.string(from: self)

        return formattedString
    }
}
