//
//  DetailsViewController.swift
//  ToDoApp
//
//  Created by ulas on 7.10.2021.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var completionTimeTextField: UITextField!
    
    var selectedTodo: CoreDataManager.TodoItem?
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = selectedTodo?.title
        detailTextField.text = selectedTodo?.detail
        titleTextField.placeholder = "Todo title"
        detailTextField.placeholder = "Todo description"
        completionTimeTextField.placeholder = "Todo completion time"
        
        titleTextField.isUserInteractionEnabled = false
        detailTextField.isUserInteractionEnabled = false
        completionTimeTextField.isUserInteractionEnabled = false
        
        //create edit button
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        createDatePicker()
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
        completionTimeTextField.isUserInteractionEnabled.toggle()
    }
    
    func createDatePicker() -> Void {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //To fix the date picker overflowing from the screen.
        if #available(iOS 13.4, *) {
           datePicker.preferredDatePickerStyle = .wheels
        }
        
        //bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerDoneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        completionTimeTextField.inputAccessoryView = toolbar
        
        //assign date picker to the text field
        completionTimeTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .dateAndTime
    }
    
    @objc func datePickerDoneButtonTapped() -> Void {
        //formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
//        completionTimeTextField.text = "\(datePicker.date)"
        completionTimeTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}
