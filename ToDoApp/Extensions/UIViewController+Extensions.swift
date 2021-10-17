//
//  UIViewController+Extensions.swift
//  ToDoApp
//
//  Created by ulas on 17.10.2021.
//

import Foundation
import UIKit

extension UIViewController {
    func setupHideKeyboardWhenTapOutside() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
