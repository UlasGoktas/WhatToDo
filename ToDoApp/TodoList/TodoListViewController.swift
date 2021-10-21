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
        LocalNotificationManager.shared.authorizeNotification()
        configureNavigationBar()

        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewDidLoad()
    }

    var todoList = [TodoListPresentation]()
    var filteredTodoList = [TodoListPresentation]()
    var viewModel: TodoListViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    @objc func orderByDateTapped() {
        //TODO: order by date fonksiyonunu iyilestir
//        filteredTodoList.sort { $0.modifyDate > $1.modifyDate }
        filteredTodoList.sort(by: {
            $0.modifyDate.compare($1.modifyDate) == .orderedDescending
        })
        self.tableView.reloadData()
    }

    @objc func addTodoButtonTapped() {
        configureAddTodoButton()
    }

    func configureNavigationBar() {
        self.title = "Todo List"
        navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColors.button)
        let addTodoBarButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addTodoButtonTapped))
        self.navigationItem.rightBarButtonItem = addTodoBarButton

        let orderBarButton = UIBarButtonItem(
            image: UIImage(systemName: "calendar.badge.clock"),
            style: .plain,
            target: self,
            action: #selector(orderByDateTapped))
        self.navigationItem.leftBarButtonItem = orderBarButton
    }

    func configureAddTodoButton() {
        let alert = UIAlertController(title: "Add New Todo", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in

            guard let todoName = alert.textFields?[0].text else { return }

            self.viewModel.saveTodo(title: todoName)
            self.viewModel.viewDidLoad()
        }
        cancelAction.setValue(UIColor(named: K.BrandColors.button), forKey: "titleTextColor")
        addAction.setValue(UIColor(named: K.BrandColors.button), forKey: "titleTextColor")

        alert.addAction(cancelAction)
        alert.addAction(addAction)

        alert.addTextField { (textField) in
            textField.text = ""
            addAction.isEnabled = false

            NotificationCenter.default.addObserver(
                forName: UITextField.textDidChangeNotification,
                object: textField, queue: OperationQueue.main) { _ in
                addAction.isEnabled = textField.text!.count > 0
            }
        }
        present(alert, animated: true, completion: nil)
    }
}

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
        return cell
    }
}

// MARK: - Search Bar Metods

extension TodoListViewController: UISearchBarDelegate {
    //TODO: arama kodunu biraz daha gelistir
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTodoList.removeAll()
        if searchText.count == 0 {
            filteredTodoList = todoList

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            for todo in todoList {
                if todo.title.isMatching(with: searchText) {
                    filteredTodoList.append(todo)
                }
            }
        }
        self.tableView.reloadData()
    }
}
