//
//  ToDoListTableViewController.swift
//  WhatToDoDemo
//
//  Created by 管 皓 on 2018/1/11.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {
    
    var itemArray = [ListItem]()
    var selectedCatagory : Catagory? {
        didSet {
            loadItems()
        }
    }
    let userDefault = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        request.predicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCatagory!.name!)
        loadItems(with: request)
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "toDoItemCell")
        cell.textLabel?.text = itemArray[indexPath.row].content
        cell.accessoryType = itemArray[indexPath.row].marked ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // delete
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].marked = !itemArray[indexPath.row].marked
        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].marked ? .checkmark : .none
        saveItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var nextAdded = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            nextAdded = alertTextField
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = ListItem(context: self.context)
            item.content = nextAdded.text!
            item.marked = false
            item.parentCatagory = self.selectedCatagory
            self.itemArray.append(item)
            self.saveItems()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func loadItems(with request: NSFetchRequest<ListItem> = ListItem.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }

}

extension ToDoListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        request.predicate = NSPredicate(format: "content CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "content", ascending: true)]
        loadItems(with: request)
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

















