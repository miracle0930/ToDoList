//
//  CatagoryTableViewController.swift
//  WhatToDoDemo
//
//  Created by 管 皓 on 2018/1/12.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import UIKit
import CoreData

class CatagoryTableViewController: UITableViewController {

    var catagories = [Catagory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catagories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catagoryCell", for: indexPath)
        cell.textLabel?.text = catagories[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatagory = catagories[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }

    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var nextAdded = UITextField()
        let alert = UIAlertController(title: "Add New Catagroy", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Catagory"
            nextAdded = alertTextField
        }
        let action = UIAlertAction(title: "Add New Catagory", style: .default) {
            (action) in
            let catagory = Catagory(context: self.context)
            catagory.name = nextAdded.text!
            self.catagories.append(catagory)
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func loadData(with request: NSFetchRequest<Catagory> = Catagory.fetchRequest()) {
        do {
            catagories = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
}
