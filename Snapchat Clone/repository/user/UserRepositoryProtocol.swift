//
//  UserRepositoryProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 21/11/21.
//

import Foundation

protocol UserRepositoryProtocol {
    typealias Completion = (User?) -> Void
    
    func insert(user: User, completion: @escaping (Bool) -> Void)
    func registerObserveUsers(completion: @escaping Completion)
    func registerObserveUser(id: String, completion: @escaping Completion)
}
