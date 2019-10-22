//
//  ViewController.swift
//  Todoey
//
//  Created by Edgar Osorio on 10/15/19.
//  Copyright © 2019 Sunset Hotels. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dfp = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TododeyItems.plist")
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
        //if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //    itemArray = items
        //}
        
        
        // Do any additional setup after loading the view.
        
        
        
    }


    //MARK TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        //Ternary Operator
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        //tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //cell.textLabel?.text = itemArray[indexPath.row].title
        
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
    }
    
    //MARK Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField  = UITextField()
        
        let alert = UIAlertController(title: "Add new ", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default){
            (action) in
            print("Added item pressed \(textField.text!)")
            let item = Item()
            item.title = textField.text!
            self.itemArray.append(item)
            
            //MARK : Added to Defaults / Reload Data
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
        
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data =  try encoder.encode(itemArray)
            try data.write(to: dfp!)
        } catch {
            print("Error Coding")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
    
        if let data = try?  Data(contentsOf: dfp!){
            let decoder = PropertyListDecoder()
            do {
                try itemArray = decoder.decode([Item].self, from: data)
            } catch {
                print ("Error decoding ")
            }
        }
        
    }
    
    
}

