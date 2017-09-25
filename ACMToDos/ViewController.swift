//
//  ViewController.swift
//  ACMToDos
//  iOS/Swift tutorial for SCU ACM 2017
//
//  Created by Mason Bruce on 8/28/17.
//  Copyright © 2017 Mason Bruce. All rights reserved.
//

// UIKit provides all the native UI elements we will use
import UIKit

// the class ViewController inherits from a UIViewController, UITableViewDataSource, and UITableViewDelegate
class ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    // The table view from Main.storyboard, the IBOutlet should be linked directly to the storyboard element
    @IBOutlet weak var tableView: UITableView!
    
    // The data stored for each item in the todo list
    struct toDoItem {
        var title: String
        var done: Bool
    }
    
    // an array of items that make up the todo list
    var todoData: [toDoItem] = []
    
    // Do all your layout and setup in viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad() // handle all the setup for UIViewController
        
        // link the tableView to this class so that we can populate and control it
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // didSelectRow is called whenever the user taps on a table row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // deselect the row
        
        if indexPath.row < todoData.count { // if the row represents valid data
            todoData[indexPath.row].done = !todoData[indexPath.row].done // change the 'done' flag
            
            todoData = sortByDone(items: todoData)
            //tableView.reloadData() 
            
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .fade)
           //tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        if indexPath.row < todoData.count {
            let item = todoData[indexPath.row]
            cell.textLabel?.text = item.title
            
            let accessory: UITableViewCellAccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return todoData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            todoData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addItem(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "Add Item", message: "Add an item to your To-Do list", preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Item to add"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (action) in
            
        }
        
        let confirmAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action) in
            let itemField = alert.textFields![0] as UITextField
            if itemField.text != "" {
                let itemToAdd = toDoItem(title: itemField.text!, done: false)
                self.tableView.beginUpdates()
                self.todoData.append(itemToAdd)
                
                self.tableView.insertRows(at: [IndexPath(row: self.todoData.count-1, section: 0)], with: .top)
                self.tableView.endUpdates()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func sortByDone(items: [toDoItem]) -> [toDoItem] {
        var sorted: [toDoItem] = []
        var completed: [toDoItem] = []
        
        for item in items {
            if item.done {
                completed.append(item)
            } else {
                sorted.append(item)
            }
        }
        
        sorted.append(contentsOf: completed)
        
        return sorted;
    }
}

