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
    private var isDatePicked = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupHideKeyboardWhenTapOutside()

        titleTextField.text = selectedTodo?.title
        detailTextField.text = selectedTodo?.detail

        if let completionTime = selectedTodo.completionTime?.timeToString() {
            completionTimeTextField.text = completionTime
        }

        titleTextField.placeholder = "Todo title"
        detailTextField.placeholder = "Todo description"
        completionTimeTextField.placeholder = "Todo completion time"

        titleTextField.isUserInteractionEnabled = false
        detailTextField.isUserInteractionEnabled = false
        completionTimeTextField.isUserInteractionEnabled = false

        // Create edit button
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        createDatePicker()

        NotificationCenter.default.addObserver(
            forName: UITextField.textDidChangeNotification,
            object: titleTextField,
            queue: OperationQueue.main) { _ in
            self.editButtonItem.isEnabled = self.titleTextField.text!.count > 0
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        if self.isEditing {
            self.editButtonItem.title = "Done"
            isDatePicked = false
            toggleUserInteraction()

        } else {
            self.editButtonItem.title = "Edit"
            coreDataManager.updateObject(
                todoId: selectedTodo.id!,
                title: titleTextField.text ?? "",
                detail: detailTextField.text ?? "",
                // Can't assign datePicker.date directly. datepicker.date has default date even is not picked.
                completionTime: isDatePicked ? datePicker.date : nil)

            // Call notification
            if let completionTime = selectedTodo.completionTime, let todoName = selectedTodo.title {
                // If completionTime passed don't trigger notification.
                if completionTime > Date() {
                    LocalNotificationManager.shared.scheduledNotificationRequest(with: completionTime, with: todoName)
                }
            }

            toggleUserInteraction()
        }
    }

    func toggleUserInteraction() {
        titleTextField.isUserInteractionEnabled.toggle()
        detailTextField.isUserInteractionEnabled.toggle()
        completionTimeTextField.isUserInteractionEnabled.toggle()
    }

    func createDatePicker() {
        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        // To fix the date picker overflowing from the screen.
        if #available(iOS 13.4, *) {
           datePicker.preferredDatePickerStyle = .wheels
        }
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: nil, action: #selector(datePickerDoneButtonTapped))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                          target: nil, action: #selector(datePickerCancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                            target: nil, action: nil)

        doneButton.tintColor = UIColor(named: K.BrandColors.button)
        cancelButton.tintColor = UIColor(named: K.BrandColors.button)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)

        completionTimeTextField.inputAccessoryView = toolbar

        // Assign date picker to the text field
        completionTimeTextField.inputView = datePicker

        // Date picker mode
        datePicker.datePickerMode = .dateAndTime
    }

    @objc func datePickerDoneButtonTapped() {
        isDatePicked = true
        completionTimeTextField.text = datePicker.date.timeToString()
        self.view.endEditing(true)
    }

    @objc func datePickerCancelButtonTapped() {
        completionTimeTextField.text = ""
        self.view.endEditing(true)
    }
}
