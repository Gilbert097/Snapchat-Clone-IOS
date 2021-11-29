//
//  UserListTableViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/11/21.
//

import Foundation

protocol UserListTableViewModelProtocol {
    typealias Output = (userSelected: Event<User?>, userListEvent: Event<UserListEventType>)
    
    func bind(_ userSelected: Event<User?>?) -> Output
    
    func loadList()
    
    var users: [User] { get }
}
