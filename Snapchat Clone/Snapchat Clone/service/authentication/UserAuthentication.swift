//
//  UserAuthentication.swift
//  Firebase Aula
//
//  Created by Gilberto Silva on 15/04/21.
//

import Foundation

public class UserAuthentication {
    let uid: String
    let email: String
    
    public init(uid: String, email: String){
        self.uid = uid
        self.email = email
    }
}
