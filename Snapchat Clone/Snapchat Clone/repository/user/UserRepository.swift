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
    private static let TAG = "UserRepository"
    
    init() {
        let database = Database.database().reference()
        users = database.child("users")
    }
    
    func insert(user: User, completion: @escaping (Bool) -> Void){
        LogUtils.printMessage(tag: UserRepository.TAG, message: "----> Start Insert User <----")
        users.child(user.id).setValue(user.toDictionary()) { error, _ in
            let isSuccess = error != nil
            if !isSuccess {
                LogUtils.printMessage(
                    tag: UserRepository.TAG,
                    message: "Insert user error -> \(String(describing: error?.localizedDescription))"
                )
            }
            LogUtils.printMessage(tag: UserRepository.TAG, message: "----> Finish Insert User <----")
            completion(isSuccess)
        }
    }
    
    func registerObserveUsers(completion: @escaping Completion){
        LogUtils.printMessage(tag: UserRepository.TAG, message: "----> Start Get Users <----")
        users.observe(.childAdded) { snapshot in
            if let data = snapshot.value as? NSDictionary{
                let user = User.create(id: snapshot.key, dictionary: data)
                LogUtils.printMessage(tag: UserRepository.TAG, message: "User -> \(user.toString())")
                completion(user)
            } else {
                LogUtils.printMessage(tag: UserRepository.TAG, message: "Get Users Error -> Error get value snapshot!")
                completion(nil)
            }
        }
    }
    
    func registerObserveUser(id: String, completion: @escaping Completion) {
        LogUtils.printMessage(tag: UserRepository.TAG, message: "----> Start Get User <----")
        users.child(id).observeSingleEvent(of: .value) {  snapshot in
            if let data = snapshot.value as? NSDictionary{
                let user = User.create(id: snapshot.key, dictionary: data)
                LogUtils.printMessage(tag: UserRepository.TAG, message: "Get User Success -> \(user.toString())")
                completion(user)
            } else {
                LogUtils.printMessage(tag: UserRepository.TAG, message: "Get User Error -> Error get value snapshot!")
                completion(nil)
            }
            LogUtils.printMessage(tag: UserRepository.TAG, message: "----> Finish Get User <----")
        }
    }
    
}
