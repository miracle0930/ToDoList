//
//  ToDoListTableViewController.swift
//  WhatToDoDemo
//
//  Created by 管 皓 on 2018/1/11.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListTableViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCatagory : Catagory? {
        didSet {
            loadItems()
        }
    }
//    let userDefault = UserDefaults.standard
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "toDoItemCell")
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.marked ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // delete
//        context.delete(todoItems[indexPath.row])
//        todoItems.remove(at: indexPath.row)
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.marked = !item.marked
                }
            } catch {
                print(error)
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var nextAdded = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            nextAdded = alertTextField
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCatagory = self.selectedCatagory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = nextAdded.text!
                        item.dateCreated = Date()
                        currentCatagory.items.append(item)
                    }
                } catch {
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        todoItems = selectedCatagory?.items.sorted(byKeyPath: "title", ascending: true)
    }

}

extension ToDoListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

















