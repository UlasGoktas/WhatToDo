//
//  TodoListViewController.swift
//  ToDoApp
//
//  Created by ulas on 19.10.2021.
//

import UIKit

class TodoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.initializeNotification()
        configureNavigationBar()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTodoList),
                                               name: Notification.Name.todoListNeedUpdate,
                                               object: nil)

        viewModel.viewDidLoad()
    }

    var todoList = [TodoListPresentation]()
    var filteredTodoList = [TodoListPresentation]()
    var viewModel: TodoListViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    @objc private func updateTodoList() {
        viewModel.viewDidLoad()
    }

    // TODO: After sorting the to-do list, it doesn't go to the details screen properly.
    @objc func orderByDateTapped() {
        viewModel.orderTodoListByDate(todoList: &filteredTodoList)
        self.tableView.reloadData()
    }

    @objc func addTodoButtonTapped() {
        configureAddTodoButton()
    }

    // MARK: - Configure Navigation Bar

    func configureNavigationBar() {
        self.title = K.NavigationBar.todoListTitle
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 24)!]

        navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColors.button)
        let addTodoBarButton = UIBarButtonItem(
            image: UIImage(systemName: K.SystemButtonName.addButton),
            style: .plain,
            target: self,
            action: #selector(addTodoButtonTapped))
        self.navigationItem.rightBarButtonItem = addTodoBarButton

        let orderBarButton = UIBarButtonItem(
            image: UIImage(systemName: K.SystemButtonName.orderByDateButton),
            style: .plain,
            target: self,
            action: #selector(orderByDateTapped))
        self.navigationItem.leftBarButtonItem = orderBarButton
    }

    // MARK: - Configure Add To-do Popup

    func configureAddTodoButton() {
        let alert = UIAlertController(title: "Add New Todo", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in

            guard let todoName = alert.textFields?[0].text else { return }

            self.viewModel.saveTodo(title: todoName)
            NotificationCenter.default.post(name: Notification.Name.todoListNeedUpdate, object: nil)
        }
        cancelAction.setValue(UIColor(named: K.BrandColors.button), forKey: "titleTextColor")
        addAction.setValue(UIColor(named: K.BrandColors.button), forKey: "titleTextColor")

        alert.addAction(cancelAction)
        alert.addAction(addAction)

        alert.addTextField { (textField) in
            textField.text = ""
            addAction.isEnabled = false

            // Don't add to-do if title is empty
            NotificationCenter.default.addObserver(
                forName: UITextField.textDidChangeNotification,
                object: textField, queue: OperationQueue.main) { _ in
                addAction.isEnabled = textField.text!.count > 0
            }
        }
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - TodoListViewModel Delegate Methods

extension TodoListViewController: TodoListViewModelDelegate {
    func handleOutput(_ output: TodoListViewModelOutput) {
        switch output {
        case .showTodoList(let todoList):
            self.todoList = todoList
            // On first opening the filtered list should show all todos
            filteredTodoList = todoList
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func navigateToRoute(to route: TodoListViewRoute) {
        switch route {
        case .showTodoDetail(let todo):
            let detailsViewController = TodoDetailsBuilder.build(with: todo)
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
}

// MARK: - TableView Delegate Methods

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    // Swipe to delete function
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            filteredTodoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            viewModel.deleteTodo(with: indexPath.row)
        }
    }
}

// MARK: - TableView Datasource Methods

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTodoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.todoCellIdentifier, for: indexPath)
        let todo = filteredTodoList[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 21)
        return cell
    }
}

// MARK: - Search Bar Metods

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMechanism(filteredList: &filteredTodoList, originalList: todoList, searchText: searchText)
        self.tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
