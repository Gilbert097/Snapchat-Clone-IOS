//
//  CreateAccountViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/04/21.
//

import Foundation

public class CreateAccountViewModel: CreateAccountViewModelProtocol {
     
    private var email: String = ""
    private var password: String = ""
    private var confirmPassword: String = ""
    private let output = Dynamic<DynamicData<CreateAccountEventType>>(.init(type: .none))
    
    func bind(input: Input) -> Output {
        input.email.bind { self.email = $0 }
        input.password.bind { self.password = $0 }
        input.confirmPassword.bind { self.confirmPassword = $0 }
       return output
    }
    
    func createAccount() {
        UserAuthenticationService.shared.createUserAuthentication(email: email, password: password) { (user, error) in
            if let user = user {
                self.output.value = .init(type: .navigation, info: InfoAlertViewModel(title: "Sucesso", message: "Usuário \(user.email) criado com sucesso!"))
            } else if let error = error {
                self.output.value = .init(type: .showMessage, info: InfoAlertViewModel(title: "Error", message: error))
            }
        }
    }
    
}
