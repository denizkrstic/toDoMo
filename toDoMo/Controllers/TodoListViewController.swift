//
//  ViewController.swift
//  toDoMo
//
//  Created by deniz ardali on 8/8/19.
//  Copyright © 2019 deniz ardali krstic. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
   
    let realm = try! Realm()
    var toDoItems : Results<Model>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
           
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No items added"
        }
        
        //yukaridaki statement bunun yerine gecer:
        //        if itemArray[indexPath.row].done == true {
        //           cell.accessoryType = .checkmark
        //        } else {
        //           cell.accessoryType = .none
        //        }
        
        return cell
    }
   
    //MARK: Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let items = toDoItems?[indexPath.row] {
            do{
                try realm.write {
                    items.done = !items.done
                }
            } catch {
                print("error selecting item \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var userTypingItem = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoMo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Model()
                        newItem.title = userTypingItem.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error saving new item \(error)")
                }
            }
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            userTypingItem = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Data Manipulation methods
    
    
    
    func loadItems () {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//
//            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
//            request.predicate = compoundPredicate
//
//        }else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            try itemArray = context.fetch(request)
//        } catch {
//            print("error fetching the context \(error)")
//        }
        tableView.reloadData()
    }
}
//MARK: SearchBar Method
extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }


//        let request : NSFetchRequest<Model> = Model.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
//        
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending:true)
//        request.sortDescriptors = [sortDescriptor]
//        
//        loadItems(with: request, predicate: predicate)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        
        }
    }
    
}

