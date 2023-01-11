//
//  onlineUsers.swift
//  GroceryList
//
//  Created by admin on 1/10/23.
//

import Foundation
import Firebase

struct Online{
    var name: String
    var email: String
    var state: String
    var id: String
    
    init(keyId: String, dictionary: [String: Any]){
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.state = dictionary["state"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
    }
}

struct OnlineModel{
    static var currenUser: String?
    static let shared = OnlineModel()
    let DBREF =  Database.database().reference()
   
    //MARK: - function
    //fetch current user
    static func currentUserInfo(_ id: String, completion: @escaping ((_ userInfo: Online?) ->())) {
        
        Database.database().reference().child("onlin/\(id)").observe(.value, with: { snapshot  in

            var userProfile: Online?
            if let dic = snapshot.value as? [String: String]{
                userProfile = Online(keyId: id, dictionary: dic)
            }
            completion(userProfile)
        })
    }
    
    func fetchAllUsersInfo(completion: @escaping([Online]) -> Void){
        var allUsers = [Online]()
        
        DBREF.child("online").observe(.childAdded){ (snapshot) in
            fetchSingleUserInfo(uuid: snapshot.key, completion: { user in
                allUsers.append(user)
                completion(allUsers)
            })
        }
    }
    
    func fetchSingleUserInfo(uuid: String, completion: @escaping(Online) -> Void){
        let dataRF = Database.database().reference()
    
        dataRF.child("online/\(uuid)").observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let userInfo = Online(keyId: uuid, dictionary: dictionary)
            completion(userInfo)
        })
    }
    
    //create new user in DB
     func createNewUser(userID:String, name: String, email: String){
        let values: [String: Any] = ["id": userID,
                                    "name": name,
                                     "email": email,
                                     "state": "online"]
        let id = DBREF.child("online").child(userID)
        id.updateChildValues(values)
        id.updateChildValues(values) { (error, ref) in
            let value = ["id": id.key!]
            DBREF.child("online").child(id.key!).updateChildValues(value)
        }
    }
    
    //update user state
    func updateState(id: String, state: String){
        let value: [String: Any]
            value = ["state": state]
        
        DBREF.child("online").child(id).updateChildValues(value)
    }
    
}
