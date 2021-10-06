//
//  TodoListViewController.swift
//  ToDoApp
//
//  Created by ulas on 30.09.2021.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var todoItemArray = [CoreDataManager.TodoItem]()
    
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Data Manupulation Methods
    
    func updateData() -> Void {
        todoItemArray = CoreDataManager.fetchObject()
    }
    
    func saveData() -> Void {
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            CoreDataManager.saveObject(title: textField.text!, detail: nil, completionTime: nil, modifyTime: nil)
            
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
        searchBar.scopeButtonTitles = ["title", "modify time"]
        searchBar.selectedScopeButtonIndex = 0
        
        searchBar.delegate = self
        
        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            todoItemArray = CoreDataManager.fetchObject()
            tableView.reloadData()
            return
        }
        
        todoItemArray = CoreDataManager.fetchObject(selectedScopeIndex: searchBar.selectedScopeButtonIndex, targetText: searchText)
        tableView.reloadData()
        print(searchText)
        
    }
    
}
