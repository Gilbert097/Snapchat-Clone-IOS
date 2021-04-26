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
    
    func bind(input: Input) -> Output {
        input.email.bind {
            print("email changed")
            self.email = $0 }
        input.password.bind { self.password = $0 }
        return output
    }
    
    
    public func login() {
        UserAuthenticationService.shared.signIn(email: email, password: password) { (user, error) in
            if let user = user {
                self.output.value = .init(type: .navigation, info: nil)
            } else if let error = error {
                self.output.value = .init(type: .showMessage, info: InfoAlertViewModel(title: "Error", message: error))
            }
        }
    }

}
