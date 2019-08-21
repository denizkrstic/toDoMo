//
//  ViewController.swift
//  toDoMo
//
//  Created by deniz ardali on 8/8/19.
//  Copyright © 2019 deniz ardali krstic. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Model]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        //yukaridaki statement bunun yerine gecer:
        //        if itemArray[indexPath.row].done == true {
        //           cell.accessoryType = .checkmark
        //        } else {
        //           cell.accessoryType = .none
        //        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //        yukaridaki statement bunun yerine gecer:
        //if  itemArray[indexPath.row].done == false {
        //            itemArray[indexPath.row].done = true
        //        } else {
        //            itemArray[indexPath.row].done = false
        //        }
        
        savingData()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var userTypingItem = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoMo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let newItem = Model()
            newItem.title = userTypingItem.text!
            
            self.itemArray.append(newItem)
            self.savingData()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            userTypingItem = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func savingData () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("error encoding item array \(error)")
        }
    }
    
    func loadItems () {
        
        let data = try? Data(contentsOf: dataFilePath!)
        let decoder = PropertyListDecoder()
        do{
            itemArray = try decoder.decode([Model].self, from: data!)
        } catch {
             print("error decoding item array \(error)")
        }
        
    }
}

