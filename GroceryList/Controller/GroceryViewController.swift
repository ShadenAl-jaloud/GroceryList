//
//  GroceryViewController.swift
//  GroceryList
//
//  Created by admin on 1/10/23.
//

import UIKit
import Firebase

class GroceryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyState: UIStackView!
    //MARK: - Var
    var groceryList = [GroceryItem]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
    //MARK: - Function
    func setUp(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        title = "Groceries to But"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addItem))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.2.badge.gearshape.fill"), style: .plain, target: self, action: #selector(onlineMember))
        
        emptyState.isHidden = true
        if groceryList.count == 0 {
            emptyState.isHidden = false
            tableView.isHidden = true
        } else {
            emptyState.isHidden = false
            tableView.isHidden = true
        }

    }
    
    private func fetch(){
         DBModel.shared.fetchAll { (allItems) in
             self.groceryList = allItems
             self.tableView.reloadData()
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
            DBModel.shared.createNewItem(title: newItem)
            self.emptyState.isHidden = true
            self.tableView.isHidden = false
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
    
}
// MARK: - Table view data source and delegat
extension GroceryViewController: UITableViewDelegate, UITableViewDataSource{
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryList.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let selectedItem = groceryList[indexPath.row]
        //I need two action here one for delete and one for edit
        let deletAction = UIContextualAction(style: .destructive, title: "delete") { action, view, completionHandler in
            DBModel.shared.deletItem(id: selectedItem.id)
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
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
