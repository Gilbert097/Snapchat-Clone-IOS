//
//  User.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 21/11/21.
//

import Foundation



class User {
    var id: String
    var fullName: String
    var email: String
    
    init(
        id: String,
        fullName: String,
        email: String
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
    }
    
    func toDictionary()-> [String: String]{
        ["fullName": fullName,
         "email": email]
    }
    
    func toString() -> String{
        "id: \(self.id), fullName: \(self.fullName), email: \(self.email)"
    }
    
    static func create(id: String, dictionary: NSDictionary) -> User{
        .init(
            id: id,
            fullName: dictionary["fullName"] as? String ?? "",
            email: dictionary["email"] as? String ?? ""
        )
    }
    
}

