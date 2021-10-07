//
//  DetailsViewController.swift
//  ToDoApp
//
//  Created by ulas on 7.10.2021.
//

import UIKit

class DetailsViewController: UIViewController {

    var selectedTodo: CoreDataManager.TodoItem?
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = selectedTodo?.title
    }

}
