//
//  DetailsViewController.swift
//  ToDoApp
//
//  Created by ulas on 7.10.2021.
//

import UIKit

class DetailsViewController: UIViewController {

    var selectedTodo: CoreDataManager.TodoItem?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = selectedTodo?.title
        detailTextField.text = selectedTodo?.detail
        titleTextField.placeholder = "Todo title"
        detailTextField.placeholder = "Todo description"
        
        titleTextField.isUserInteractionEnabled = false
        detailTextField.isUserInteractionEnabled = false
        
        //create edit button
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if self.isEditing {
            self.editButtonItem.title = "Done"
            toggleUserInteraction()
        } else {
            self.editButtonItem.title = "Edit"
            toggleUserInteraction()
        }
    }
    
    func toggleUserInteraction() -> Void {
        titleTextField.isUserInteractionEnabled.toggle()
        detailTextField.isUserInteractionEnabled.toggle()
    }
}
