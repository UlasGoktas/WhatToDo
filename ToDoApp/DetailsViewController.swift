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
    
    var selectedTodo: Todo!
    var coreDataManager = CoreDataManager()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = selectedTodo?.title
        detailTextField.text = selectedTodo?.detail
        
        if let completionTime = dateFormatter(pickedDate: selectedTodo.completionTime) {
            completionTimeTextField.text = completionTime
        }
        
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
            coreDataManager.updateObject(id: selectedTodo.id!, title: titleTextField.text ?? "", detail: detailTextField.text ?? "", completionTime: datePicker.date)
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
        
        completionTimeTextField.text = dateFormatter(pickedDate: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    func dateFormatter(pickedDate: Date?) -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        guard let pickedDate = pickedDate else {
            return nil
        }
        
        let formattedString = formatter.string(from: pickedDate)
        
        return formattedString
    }
}
