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
    
    func registerObserveUsers(completion: @escaping Completion){
        users.observe(.childAdded) { [weak self] snapshot in
            guard let self = self else { return }
            self.notifyCompletion(snapshot: snapshot, completion: completion)
        }
    }
    
    func registerObserveUser(id: String, completion: @escaping Completion) {
        users.child(id).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            self.notifyCompletion(snapshot: snapshot, completion: completion)
        }
    }
    
    private func notifyCompletion(
        snapshot: DataSnapshot,
        completion: @escaping Completion
    ) {
        if let data = snapshot.value as? NSDictionary{
            let user = User.create(id: snapshot.key, dictionary: data)
            print(user.toString())
            completion(user)
        } else {
            print("Error get value snapshot!")
            completion(nil)
        }
    }
    
}
