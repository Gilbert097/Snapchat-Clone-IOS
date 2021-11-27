//
//  UserRepositoryProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 21/11/21.
//

import Foundation

protocol UserRepositoryProtocol {
    func insert(user: User, completion: @escaping (Bool) -> Void)
    func registerObserveUser(completion: @escaping (User) -> Void)
}
