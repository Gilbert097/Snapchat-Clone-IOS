//
//  LoginViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/04/21.
//

import Foundation

public class LoginViewModel: LoginViewModelProtocol {
    private static let TAG = "LoginViewModel"
    
    private var email: String = ""
    private var password: String = ""
    private let output = Event<EventData<LoginEventType>>(.init(type: .none))
    private let authenticationService: UserAuthenticationServiceProtocol
    private let userRepository: UserRepositoryProtocol
    
    init(
        authenticationService: UserAuthenticationServiceProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.authenticationService = authenticationService
        self.userRepository = userRepository
    }
    
    func bind(input: Input) -> Output {
        input.email.bind { [weak self] in self?.email = $0 }
        input.password.bind { [weak self] in self?.password = $0 }
        return output
    }
    
    public func login() {
        if !email.isEmpty && !password.isEmpty {
            self.authenticationService.signIn(email: email, password: password) { [weak self] (userId, error) in
                guard let self = self else { return }
                if let userId = userId {
                    LogUtils.printMessage(tag: LoginViewModel.TAG, message: "UserId -> \(userId)")
                    self.userRepository.registerObserveUser(id: userId) { user in
                        LogUtils.printMessage(tag: LoginViewModel.TAG, message: "Set current user \(String(describing: user?.fullName))")
                        AppRepository.shared.setCurrentUser(currentUser: user)
                        self.output.value = .init(type: .navigationToMain, info: nil)
                    }
                } else if let error = error {
                    LogUtils.printMessage(tag: LoginViewModel.TAG, message: "Error -> \(error)")
                    self.output.value = .init(type: .showMessage, info: InfoAlertViewModel(title: "Error", message: error))
                }
            }
        } else {
            output.value = .init(type: .showMessage, info: InfoAlertViewModel(title: "Error", message: "Email and password required!"))
        }
    }
    
}
