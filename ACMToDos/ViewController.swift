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
            todoData[indexPath.row].done = !todoData[indexPath.row].done // toggle the 'done' flag
            
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .fade) // update the view
        }
    }
    
    // layout each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a variable representing a cell in your table
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        if indexPath.row < todoData.count { // if it's valid
            let item = todoData[indexPath.row] // get the item in your array of tasks
            cell.textLabel?.text = item.title // set the label on the cell to represent the given item
            
            // if the task is complete, set the accessory to a check mark, else do not
            if item.done {
                 cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell // return the styled cell
    }
    
    // we only want 1 section in this tableView, but there can be more
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // the number of rows in our table is the number of items in our array of todos
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return todoData.count
    }

    // set if the table cells can be edittied, in this case if they can be removed or not
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // handle deletion of rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { // if the editing style is deletion
            tableView.beginUpdates() // begin updating the tableView
            todoData.remove(at: indexPath.row) // remove the item from our array
            tableView.deleteRows(at: [indexPath], with: .top) // delete that row in the table
            tableView.endUpdates() // stop updating the tableView
        }
    }
    

    // Add an item to the todo list
    // this IBAction should be linked directly to the + button in the storyboard
    @IBAction func addItem(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "Add Item", message: "Add an item to your To-Do list", preferredStyle: .alert) // creat a view for a pop-up
        
        // add a text field to read in the task
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Item to add"
        }
        
        // create an empty action to handle cancelation
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (action) in
            // Do nothing
        }
        
        alert.addAction(cancelAction) // add the action to the alert
        
        // create a confirmation action and handle adding something to the table
        let confirmAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action) in
            let itemField = alert.textFields![0] as UITextField // get the textfield we added to the alert
            if itemField.text != "" { // if the alert has text
                let itemToAdd = toDoItem(title: itemField.text!, done: false) // create a new toDoItem with the user-specified task
                self.tableView.beginUpdates() // start updating the tableView
                self.todoData.append(itemToAdd) // add the item to the list
                
                self.tableView.insertRows(at: [IndexPath(row: self.todoData.count-1, section: 0)], with: .top) // insert the new item in the table
                self.tableView.endUpdates() // stop updating the tableView
            }
        }
        
        alert.addAction(confirmAction) // add the action to the alert
        
        self.present(alert, animated: true, completion: nil) // present the alert to the user
    }
    
    
    // this is used to handle memory issues, we shouldn't encounter any with this app
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

