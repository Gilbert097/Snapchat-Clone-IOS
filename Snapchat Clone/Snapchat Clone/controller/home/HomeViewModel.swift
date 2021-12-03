//
//  HomeViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/04/21.
//

import Foundation

public class HomeViewModel:HomeViewModelProtocol {
    
    private let output = Event<EventData<HomeEventType>>(.init(type: .none))
    private let authenticationService: UserAuthenticationServiceProtocol
    
    init(authenticationService: UserAuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
    }
    
    func bind() -> Output {
        output
    }
    
    func checkUserLogged() {
        self.authenticationService.registerUserAuthenticationState { [weak self] (isUserLogged) in
            //TODO[GIL] - Recuperar o usuário logado.
            if isUserLogged {
                self?.output.value = .init(type: .navigationToMain)
            }
        }
    }
    
}
