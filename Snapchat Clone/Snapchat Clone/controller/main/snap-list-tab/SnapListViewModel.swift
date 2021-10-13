//
//  SnapDetailViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 12/10/21.
//

import Foundation

public class SnapListViewModel: SnapListViewModelProtocol {
   
    private let output = Dynamic<DynamicData<SnapListEventType>>(.init(type: .none))
    private let authenticationService: UserAuthenticationServiceProtocol
    
    init(authenticationService: UserAuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
    }
    
    func bind() -> Output {
        return output
    }
    
    func signOut() {
        authenticationService.signOut()
        output.value = .init(type: .navigationToBack)
    }

}
