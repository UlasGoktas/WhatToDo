//
//  TodoDetailsViewController.swift
//  ToDoApp
//
//  Created by ulas on 20.10.2021.
//

import UIKit

class TodoDetailsViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var completionDateTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardWhenTapOutside()

        configureDatePicker()
        configureNavigationBar()

        viewModel.viewDidLoad()
    }

    var viewModel: TodoDetailsViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    var selectedTodo: TodoDetailsPresentation!
    let datePicker = UIDatePicker()
    private var isDatePicked = false

    func configureNavigationBar() {
        self.title = "Details"
        self.navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColors.button)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func configureDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        // To fix the date picker overflowing from the screen.
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: nil,
                                         action: #selector(datePickerDoneButtonTapped))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: nil,
                                           action: #selector(datePickerCancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
                                                UIBarButtonItem.SystemItem.flexibleSpace,
                                            target: nil,
                                            action: nil)

        doneButton.tintColor = UIColor(named: K.BrandColors.button)
        cancelButton.tintColor = UIColor(named: K.BrandColors.button)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)

        completionDateTextField.inputAccessoryView = toolbar

        // Assign date picker to the completionDateTextField
        completionDateTextField.inputView = datePicker

        // Date picker mode
        datePicker.datePickerMode = .dateAndTime
    }

    @objc func datePickerDoneButtonTapped() {
        isDatePicked = true
        completionDateTextField.text = datePicker.date.timeToString()
        self.view.endEditing(true)
    }

    @objc func datePickerCancelButtonTapped() {
        self.view.endEditing(true)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if self.isEditing {
            self.editButtonItem.title = "Done"
            isDatePicked = false
            toggleUserInteraction()

        } else {
            self.editButtonItem.title = "Edit"
            viewModel.updateTodo(with: selectedTodo.id,
                                 title: titleTextField.text!,
                                 description: descriptionTextField.text ?? "",
            // Can't assign datePicker.date directly. datepicker.date has default date even is not picked.
                                 completionDate: isDatePicked ? datePicker.date : nil)

            // If completionDate passed don't trigger notification.
            if datePicker.date > Date() {
                print(datePicker.date)
                    LocalNotificationManager.shared.scheduledNotificationRequest(
                        with: datePicker.date,
                        with: titleTextField.text!)
                }
            toggleUserInteraction()
        }
    }

    func toggleUserInteraction() {
        titleTextField.isUserInteractionEnabled.toggle()
        descriptionTextField.isUserInteractionEnabled.toggle()
        completionDateTextField.isUserInteractionEnabled.toggle()
    }
}

extension TodoDetailsViewController: TodoDetailsViewModelDelegate {
    func showTodoDetails(_ todo: TodoDetailsPresentation) {
        selectedTodo = todo
        titleTextField.placeholder = "Todo title"
        descriptionTextField.placeholder = "Todo description"
        completionDateTextField.placeholder = "Todo completion date"

        titleTextField.isUserInteractionEnabled = false
        descriptionTextField.isUserInteractionEnabled = false
        completionDateTextField.isUserInteractionEnabled = false

        titleTextField.text = todo.title
        descriptionTextField.text = todo.description
        completionDateTextField.text = todo.completionDate?.timeToString()
    }
}
