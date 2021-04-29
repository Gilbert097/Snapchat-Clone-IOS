//
//  HomeViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/04/21.
//

import Foundation

public class HomeViewModel:NSObject, HomeViewModelProtocol {
    
    private let output = Dynamic<DynamicData<HomeEventType>>(.init(type: .none))
    private let authenticationService: UserAuthenticationServiceProtocol
    
    init(authenticationService: UserAuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
    }
    
    func bind() -> Output {
        output
    }
    
    func checkUserLogged() {
        self.authenticationService.getUserAuthenticationState { (isUserLogged) in
            if isUserLogged {
                self.output.value = .init(type: .navigationToMain)
            }
        }
    }
    
}