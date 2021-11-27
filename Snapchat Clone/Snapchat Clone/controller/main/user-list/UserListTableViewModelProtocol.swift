//
//  UserListTableViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/11/21.
//

import Foundation

protocol UserListTableViewModelProtocol {
    typealias Output = (userSelected: Dynamic<User?>, userListEvent: Dynamic<UserListEventType>)
    
    func bind() -> Output
    
    func loadList()
    
    var users: [User] { get }
}
