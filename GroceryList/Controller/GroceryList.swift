//
//  GroceryList.swift
//  GroceryList
//
//  Created by admin on 1/8/23.
//

import UIKit
import Firebase

class GroceryList: UITableViewController {


    //MARK: - Var
    var groceryList = [GroceryItem]()
    var currentUser = [Online]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetch()
        fetchCurrentUser()
    }
    
    //MARK: - Function
    func setUp(){
        
        tableView.rowHeight = 70
        title = "Groceries to But"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addItem))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.2.badge.gearshape.fill"), style: .plain, target: self, action: #selector(onlineMember))
    }
    
    private func fetch(){
        DBModel.shared.check { FirbaseJSON in
            if FirbaseJSON.count == 2 {
                DBModel.shared.fetchAll { (allItems) in
                     self.groceryList = allItems
                     self.tableView.reloadData()
                 }
            } else {
                self.groceryList = [GroceryItem]()
                self.tableView.reloadData()
            }
        }
    }
  
    func fetchCurrentUser(){
        OnlineModel.shared.fetchAllUsersInfo { users in
            self.monitorOnline(user: users)
        }
    }
    
    func monitorOnline(user: [Online]){
        currentUser.removeAll()
        guard let userId = OnlineModel.currenUser else { return }
        for onlin in user {
            if onlin.id == userId{
                self.currentUser.append(onlin)
            }
        }
    }
    
    @objc func addItem(){
        let alertController = UIAlertController(title: "Add Item", message: "write new grocery item", preferredStyle: .alert)
        
        alertController.addTextField{ field in
            field.placeholder = "Add New Item"
        }
       
        alertController.addAction(UIAlertAction(title: "Save", style: .default , handler: { alert in
            //save new item
            let item = alertController.textFields![0] as UITextField
            guard let newItem = item.text else { return }
            DBModel.shared.createNewItem(title: newItem, creator: self.currentUser[0].name)
            self.tableView.reloadData()
           
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    @objc func onlineMember(){
      let onlineMonitor = storyboard?.instantiateViewController(withIdentifier: "onlineMember") as! OnlineMember
        navigationItem.backButtonTitle = "list"
        self.navigationController?.pushViewController(onlineMonitor, animated: true)
    }

    // MARK: - Table view data source and delegat
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath) as! GroceryCell
        cell.title.text = groceryList[indexPath.row].title
        cell.createdBy.text = groceryList[indexPath.row].createdBy
        if groceryList[indexPath.row].complete == true{
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    //swip to delet or edit
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let selectedItem = groceryList[indexPath.row]
        //I need two action here one for delete and one for edit
        let deletAction = UIContextualAction(style: .destructive, title: "delete") { action, view, completionHandler in
            
            DBModel.shared.deletItem(itemId: selectedItem.id)
            self.fetch()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "edit") { action, view,
            completionHandler in
            
            let alertController = UIAlertController(title: "Edit Item", message: .none, preferredStyle: .alert)
            
            alertController.addTextField{ field in
                field.text = selectedItem.title
            }
           
            alertController.addAction(UIAlertAction(title: "Save", style: .default , handler: { alert in
                //save change
                let item = alertController.textFields![0] as UITextField
                guard let updatedItem = item.text else { return }
                DBModel.shared.editItem(id: selectedItem.id, title: updatedItem)
                self.fetch()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alertController, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [deletAction, editAction])
    }
    
    //check mark for completion
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = groceryList[indexPath.row]
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            DBModel.shared.editItem(id: item.id,isComplete: false, title: "")
            fetch()
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            DBModel.shared.editItem(id: item.id,isComplete: true, title: "")
            fetch()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
