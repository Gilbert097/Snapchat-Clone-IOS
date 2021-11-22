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
    var password: String
    var confirmPassword: String
    
    init(
        id: String,
        fullName: String,
        email: String,
        password: String,
        confirmPassword: String
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
    
    func toDictionary()-> [String: String]{
        ["fullName": fullName,
         "email": email]
    }
    
}

