//
//  LoginViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/04/21.
//

import Foundation

public class LoginViewModel: LoginViewModelProtocol {
    
    private var email: String = ""
    private var password: String = ""
    private let output = Event<EventData<LoginEventType>>(.init(type: .none))
    private let authenticationService: UserAuthenticationServiceProtocol
    
    init(authenticationService: UserAuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
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
                if userId != nil {
                    //TODO[GIL] - Recuperar usuário do banco e setar no AppRepository
                    self.output.value = .init(type: .navigationToMain, info: nil)
                } else if let error = error {
                    self.output.value = .init(type: .showMessage, info: InfoAlertViewModel(title: "Error", message: error))
                }
            }
        } else {
            output.value = .init(type: .showMessage, info: InfoAlertViewModel(title: "Error", message: "Email and password required!"))
        }
    }
    
}
