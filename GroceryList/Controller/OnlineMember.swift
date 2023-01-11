//
//  OnlineMember.swift
//  GroceryList
//
//  Created by admin on 1/8/23.
//

import UIKit
import FirebaseAuth

class OnlineMember: UITableViewController {
    
    //MARK: - Var
    var handle: AuthStateDidChangeListenerHandle?
    var onlineUser = [Online]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Family(Online)"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut))
        tableView.rowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
   
    //MARK: - Function
    func fetch(){
        OnlineModel.shared.fetchAllUsersInfo { users in
            self.monitorOnline(user: users)
        }
    }
    
    func monitorOnline(user: [Online]){
        onlineUser.removeAll()
        for onlin in user {
            if onlin.state == "online"{
                self.onlineUser.append(onlin)
            }
        }
        self.tableView.reloadData()
        
    }
    @objc func signOut(){
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            guard let userId = user?.uid else { return }
            OnlineModel.shared.updateState(id: userId, state: "offline")
            OnlineModel.currenUser = nil
            try? Auth.auth().signOut()
        }
        

        let loginController = storyboard?.instantiateViewController(withIdentifier: "loginView") as! ViewController
        let login = UINavigationController(rootViewController: loginController)
        login.modalPresentationStyle = .fullScreen
        self.navigationController?.present(login, animated: true)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        onlineUser.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! MemberCell
        cell.userNameLabel.text = onlineUser[indexPath.row].name
        cell.userEmailLabel.text = onlineUser[indexPath.row].email
        return cell
    }

}
