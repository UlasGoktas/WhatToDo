//
//  TodoListViewController.swift
//  ToDoApp
//
//  Created by ulas on 30.09.2021.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //path for core data database file
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }
    

    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemCellIdentifier, for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        //add checkmark for done items
//        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
     }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //toggle done state
//        itemArray[indexPath.row].done.toggle()
        
        //change value with different way
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //eleman silerken once context icerisinden sonra asil listemizden siliyoruz yoksa index out of range hatasi aliriz
        //CRUD operationlar arasindan read haricinde bir islem yaptigimizda saveItems() metodunu cagirip contextimizi kaydetmemiz gerekir.
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            
            let newItem = Item(context: self.context)
            
            
            newItem.name = textField.text!
//            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
            
            
            
//            if let newItem.name = textField.text {
//                self.itemArray.append(newItem)
//
//            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
    
    func saveItems() -> Void {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(context)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems() -> Void {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
    
}
