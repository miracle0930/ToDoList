//
//  CatagoryTableViewController.swift
//  WhatToDoDemo
//
//  Created by 管 皓 on 2018/1/12.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import UIKit
import RealmSwift

class CatagoryTableViewController: UITableViewController {

    var catagories: Results<Catagory>?
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catagoryCell", for: indexPath)
        cell.textLabel?.text = catagories?[indexPath.row].name ?? "No Catagories Added Yet"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatagory = catagories?[indexPath.row]
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
            let catagory = Catagory()
            catagory.name = nextAdded.text!
            self.save(catagory: catagory)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(catagory: Catagory) {
        do {
            try realm.write {
                realm.add(catagory)
            }
        } catch {
            print(error)
        }
    }
    
    func loadData() {
        catagories = realm.objects(Catagory.self)
    }
    
}
