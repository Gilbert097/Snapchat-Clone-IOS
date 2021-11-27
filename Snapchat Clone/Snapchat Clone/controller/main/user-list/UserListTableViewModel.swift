//
//  UserListTableViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/11/21.
//

import Foundation
class UserListTableViewModel: UserListTableViewModelProtocol{
    
    private let output: Output = (userSelected: .init(nil), userListEvent: .init(.none))
    private let repository: UserRepositoryProtocol
    var users: [User] = []
    
    init(repository: UserRepositoryProtocol){
        self.repository = repository
    }
    
    func bind() -> Output {
        output
    }
    
    func loadList(){
        self.repository.registerObserveUser { user in
            self.users.append(user)
            self.output.userListEvent.value = .reloadList
        }
    }
    
    
}
