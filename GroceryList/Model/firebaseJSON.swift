//
//  firebaseJSON.swift
//  GroceryList
//
//  Created by admin on 1/11/23.
//

import Foundation

struct FirbaseJSON{
    var items: [JSONItems]?
     var online: [JSONOnline]?
}

struct JSONItems{
    var complete: Bool
    var createdBy: String
    var id: String
    var title: String
}

struct JSONOnline{
    var email: String
    var id: String
    var name: String
    var state: String
    
}


