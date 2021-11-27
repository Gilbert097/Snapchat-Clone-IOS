//
//  UserRepository.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 21/11/21.
//

import Foundation
import FirebaseDatabase

class UserRepository: UserRepositoryProtocol{
    
    let users: DatabaseReference
    
    init() {
        let database = Database.database().reference()
        users = database.child("users")
    }
    
    func insert(user: User, completion: @escaping (Bool) -> Void){
        users.child(user.id).setValue(user.toDictionary()) { error, _ in
            let isSuccess = error != nil
            if !isSuccess {
                print("Error creating user \(user.fullName)")
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            completion(isSuccess)
        }
    }
    
    func registerObserveUser(completion: @escaping (User) -> Void){
        users.observe(.childAdded) { snapshot in
            if let data = snapshot.value as? NSDictionary{
                let user = User.create(id: snapshot.key, dictionary: data)
                print(user.toString())
                completion(user)
            }
        }
    }
    
}
