//
//  CategoryTableViewController.swift
//  toDoMo
//
//  Created by deniz ardali on 8/23/19.
//  Copyright © 2019 deniz ardali krstic. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadData()
    }
    
    
    //MARK: Tableview datasource methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name

        return cell
    }
    //MARK: Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
       
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexpath.row]
        }
    
    }
    
    
    //MARK: Add button function
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var userAddingCategory = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoMo Category", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
           
            let newCategory = Category(context: self.context)
            newCategory.name = userAddingCategory.text
            
            self.categoryArray.append(newCategory)
            self.SaveData()
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
    
    func SaveData () {
        do {
            try context.save()
        }catch {
            print("error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    func LoadData (with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            try categoryArray = context.fetch(request)
        }catch{
            print("error loading categories \(error)")
        }
        tableView.reloadData()
    }

}
