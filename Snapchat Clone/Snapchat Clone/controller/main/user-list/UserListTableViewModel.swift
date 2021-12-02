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
    var users: [UserItemViewModel] = []
    
    init(repository: UserRepositoryProtocol){
        self.repository = repository
    }
    
    func bind(_ userSelected: Event<UserItemViewModel?>? = nil) -> Output {
        userSelected?.bind { [weak self] in self?.output.userSelected.value = $0 }
        return output
    }
    
    func loadList(){
        self.repository.registerObserveUsers {[weak self] user in
            guard let self = self, let user = user else { return }
            self.users.append(.init(user: user))
            self.output.userListEvent.value = .reloadList
        }
    }
}
