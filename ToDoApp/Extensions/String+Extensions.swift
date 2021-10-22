//
//  String+Extensions.swift
//  ToDoApp
//
//  Created by ulas on 20.10.2021.
//

import Foundation

extension String {
    func isMatching(with text: String) -> Bool {
        let result: Bool = self.lowercased().contains(text.lowercased())
        return result
    }
}
