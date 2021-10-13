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
    private let output = Dynamic<DynamicData<LoginEventType>>(.init(type: .none))
    private let authenticationService: UserAuthenticationServiceProtocol
    
    init(authenticationService: UserAuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
    }
    
    func bind(input: Input) -> Output {
        input.email.bind { self.email = $0 }
        input.password.bind { self.password = $0 }
        return output
    }
    
    public func login() {
        self.authenticationService.signIn(email: email, password: password) { (user, error) in
            if user != nil {
                self.output.value = .init(type: .navigationToMain, info: nil)
            } else if let error = error {
                self.output.value = .init(type: .showMessage, info: InfoAlertViewModel(title: "Error", message: error))
            }
        }
    }

}
