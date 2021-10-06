//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by ulas on 29.09.2021.
//

import UIKit
import CoreData

class CoreDataManager {
    
    struct TodoItem {
        var title: String?
        var detail: String?
        var completionTime: Date?
        var modifyTime: Date?
    }
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //save object into Core Data
    class func saveObject(title: String, detail: String?, completionTime: Date?, modifyTime: Date?) {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Todo", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(title, forKey: "title")
        managedObject.setValue(detail, forKey: "detail")
        managedObject.setValue(completionTime, forKey: "completionTime")
        managedObject.setValue(modifyTime, forKey: "modifyTime")
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    //fetch all the objects from Core Data
    class func fetchObject(selectedScopeIndex: Int? = nil, targetText: String? = nil) -> [TodoItem] {
        
        var todoArray = [TodoItem]()
        
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        if let index = selectedScopeIndex, let text = targetText {
            var filterKeyword = ""
            
            switch index {
            case 0:
                filterKeyword = "title"
            case 1:
                filterKeyword = "modifyTime"
            default:
                print("Unknown selectedScopeIndex")
            }
            
            let predicate = NSPredicate(format: "\(filterKeyword) contains[c] %@", text)
            fetchRequest.predicate = predicate
        }
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                let todo = TodoItem(title: item.title, detail: item.detail, completionTime: item.completionTime, modifyTime: item.modifyTime)
                todoArray.append(todo)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return todoArray
    }
    
}
