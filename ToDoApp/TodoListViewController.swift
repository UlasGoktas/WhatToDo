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
        
        updateData()
        setUpSearchBar()
        
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
        
//        tableView.deselectRow(at: indexPath, animated: true)
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
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in

//            CoreDataManager.createObject(title: textField.text!, detail: nil, completionTime: nil, modifyTime: nil)
            self.coreDataManager.saveObject(title: textField.text!, detail: nil, completionTime: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
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
