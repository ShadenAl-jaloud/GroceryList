//
//  postServies.swift
//  GroceryList
//
//  Created by admin on 1/10/23.
//

import Foundation
import Firebase

struct GroceryItem{
    var title: String
    var id: String
    var complete: Bool
    var createdBy: String
    
    init(keyId: String, dictionary: [String: Any]){
        
        self.title = dictionary["title"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.complete = dictionary["complete"] as? Bool ?? false
        self.createdBy = dictionary["createdBy"] as? String ?? ""
    }
}



struct DBModel{
    
    static let shared = DBModel()
    let databaseREF =  Database.database().reference()

    //MARK: - function

    //fetch all item from DB
    func fetchAll(completion: @escaping([GroceryItem]) -> Void){
        var allGroceries = [GroceryItem]()
        
             databaseREF.child("items").queryOrdered(byChild: "complete").observe(.childAdded){ (snapshot) in
                 fetchOneItem(id: snapshot.key) { (item)  in
                    allGroceries.append(item)
                     completion(allGroceries)
                }
            }
    }
    //this func will check if there is items in the firebease or not
    func check(completion: @escaping(NSDictionary) -> Void){
        Database.database().reference(fromURL: "https://grocery-d29d9-default-rtdb.firebaseio.com/").observe(.value) { snapshot,err  in
            guard let dic = snapshot.value as? NSDictionary else {
                print("field to DB")
              return
            }
    
            completion(dic)
        }
    }
    
    //fetch single item
    func fetchOneItem(id: String, completion: @escaping(GroceryItem) -> Void){
        databaseREF.child("items").child(id).observeSingleEvent(of: .value) { (snapchot) in
            
            guard let dictionary = snapchot.value as? [String: Any] else { return }
            
            let groceryItem = GroceryItem(keyId: id, dictionary: dictionary)
            completion(groceryItem)
        }

    }
   
    //create new item in DB
    func createNewItem(title: String, creator: String){
        let values: [String: Any] = ["title": title,
                                    "complete": false,
                                     "createdBy": creator]
        
        let id = databaseREF.child("items").childByAutoId()
        id.updateChildValues(values)
        id.updateChildValues(values) { (error, ref) in
            let value = ["id": id.key!]
            databaseREF.child("items").child(id.key!).updateChildValues(value)
        }
    }
    
    //edit exusting item
    func editItem(id: String, isComplete: Bool = false, title: String){
        let value: [String: Any]
        
        if title != ""{
            value = ["title": title,
                    "complete": isComplete]
        } else {
            value = ["complete": isComplete]
        }
        
        databaseREF.child("items").child(id).updateChildValues(value)
    }
    
    //delet item
    func deletItem(itemId: String){
        let root = databaseREF.child("items")
        root.child(itemId).removeValue()
    }
}
