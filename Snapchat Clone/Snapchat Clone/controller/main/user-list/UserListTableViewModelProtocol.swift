//
//  UserListTableViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/11/21.
//

import Foundation

protocol UserListTableViewModelProtocol {
    typealias Output = (userSelected: Event<UserItemViewModel?>, userListEvent: Event<UserListEventType>)
    
    func bind(_ userSelected: Event<UserItemViewModel?>?) -> Output
    
    func loadList()
    
    var users: [UserItemViewModel] { get }
}
