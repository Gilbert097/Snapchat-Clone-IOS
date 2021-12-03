//
//  HomeViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/04/21.
//

import Foundation

public class HomeViewModel: HomeViewModelProtocol {
    private static let TAG = "HomeViewModel"
    
    private let output = Event<EventData<HomeEventType>>(.init(type: .none))
    private let authenticationService: UserAuthenticationServiceProtocol
    private let userRepository: UserRepositoryProtocol
    
    init(
        authenticationService: UserAuthenticationServiceProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.authenticationService = authenticationService
        self.userRepository = userRepository
    }
    
    func bind() -> Output {
        output
    }
    
    func checkUserLogged() {
        self.authenticationService.registerUserAuthenticationState { [weak self] (userId) in
            guard let self = self else { return }
            
            self.authenticationService.removeUserAuthenticationState()
            if let userId = userId {
                self.userRepository.registerObserveUser(id: userId) { user in
                    LogUtils.printMessage(tag: HomeViewModel.TAG, message: "Set current user \(String(describing: user?.fullName))")
                    AppRepository.shared.setCurrentUser(currentUser: user)
                    self.output.value = .init(type: .navigationToMain)
                }
            }
        }
    }
    
}
