//
//  CategoryTableViewController.swift
//  toDoMo
//
//  Created by deniz ardali on 8/23/19.
//  Copyright © 2019 deniz ardali krstic. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    var categories : Results<Category>?
    
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadData()
    }
    
    
    //MARK: Tableview datasource methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"

        return cell
    }
    //MARK: Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
       
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexpath.row]
        }
    
    }
    
    
    //MARK: Add button function
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var userAddingCategory = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoMo Category", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
           
            let newCategory = Category()
            newCategory.name = userAddingCategory.text!
            
           
            self.SaveData(category: newCategory)
            self.tableView.reloadData()
       
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            userAddingCategory = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
      
    }

    //MARK: Data Manipulation methods
    
    func SaveData (category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    func LoadData () {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }

}
