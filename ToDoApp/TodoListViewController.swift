//
//  TodoListViewController.swift
//  ToDoApp
//
//  Created by ulas on 30.09.2021.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var todoItemArray = [Todo]()
    var coreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocalNotificationManager.shared.authorizeNotification()
        
        updateData()
        setUpSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: write condition for checking todo element values changed or not
        tableView.reloadData()
    }
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.todoCellIdentifier, for: indexPath)
        
        let item = todoItemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.detailSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailsViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedTodo = todoItemArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manupulation Methods
    
    func updateData() -> Void {
        todoItemArray = coreDataManager.fetchObject()
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todo", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            
            guard let todoName = alert.textFields?[0].text else { return }
            
            self.coreDataManager.saveObject(title: todoName, detail: nil, completionTime: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        alert.addTextField { (textField) in
            textField.text = ""
            addAction.isEnabled = false
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                addAction.isEnabled = textField.text!.count > 0
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Search Bar Metods

extension TodoListViewController: UISearchBarDelegate {
    
    func setUpSearchBar() -> Void {
        
        let screenWidth: CGFloat = self.view.bounds.width
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70))
        
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = [K.SearchBar.scopeButtonTitle, K.SearchBar.scopeButtonModifyTime]
        searchBar.selectedScopeButtonIndex = 0
        
        searchBar.delegate = self
        
        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            todoItemArray = coreDataManager.fetchObject()
            tableView.reloadData()
            return
        }
        
        todoItemArray = coreDataManager.fetchObject(selectedScopeIndex: searchBar.selectedScopeButtonIndex, searchText: searchText)
        tableView.reloadData()
        
    }
    
}
