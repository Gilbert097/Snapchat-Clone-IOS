//
//  CreateAccountViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/04/21.
//

import Foundation

public class CreateAccountViewModel: CreateAccountViewModelProtocol {
    
    private var fullName: String = ""
    private var email: String = ""
    private var password: String = ""
    private var confirmPassword: String = ""
    private let output = Dynamic<DynamicData<CreateAccountEventType>>(.init(type: .none))
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
        input.fullName.bind { self.fullName = $0 }
        input.email.bind { self.email = $0 }
        input.password.bind { self.password = $0 }
        input.confirmPassword.bind { self.confirmPassword = $0 }
       return output
    }
    
    func createAccount() {
        self.authenticationService.createUserAuthentication(email: email, password: password) { (user, error) in
            if let user = user {
                let userModel = User(
                    id: user.uid,
                    fullName: self.fullName,
                    email: self.email,
                    password: self.password,
                    confirmPassword: self.password
                )
                self.userRepository.insert(user: userModel) { isSuccess in
                    if isSuccess {
                    self.output.value = .init(type: .navigation, info: InfoAlertViewModel(title: "Sucesso", message: "Usuário \(user.email) criado com sucesso!"))
                    }else{
                        self.output.value = .init(type: .showMessage, info: InfoAlertViewModel(title: "Error", message: "Error ao criar usuário!"))
                    }
                    
                }
            } else if let error = error {
                self.output.value = .init(type: .showMessage, info: InfoAlertViewModel(title: "Error", message: error))
            }
        }
    }
    
}
