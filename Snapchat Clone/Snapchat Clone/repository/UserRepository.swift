//
//  UserRepository.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 21/11/21.
//

import Foundation
import FirebaseDatabase

class UserRepository: UserRepositoryProtocol{
    
    let database: DatabaseReference
    
    init() {
        database = Database.database().reference()
    }
    
    func insert(user: User, completion: @escaping (Bool) -> Void){
        let users = database.child("users")
        users.child(user.id).setValue(user.toDictionary()) { error, _ in
            let isSuccess = error != nil
            if !isSuccess {
                print("Error creating user \(user.fullName)")
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            completion(isSuccess)
        }
    }
    
}
