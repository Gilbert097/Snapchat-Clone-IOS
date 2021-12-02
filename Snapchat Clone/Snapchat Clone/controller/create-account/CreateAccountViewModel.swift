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
    private let output = Event<EventData<CreateAccountEventType>>(.init(type: .none))
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
        input.fullName.bind { [weak self] in self?.fullName = $0 }
        input.email.bind { [weak self] in self?.email = $0 }
        input.password.bind { [weak self] in self?.password = $0 }
        input.confirmPassword.bind { [weak self] in self?.confirmPassword = $0 }
        return output
    }
    
    func createAccount() {
        self.authenticationService.create(email: email, password: password) { [weak self] (userId, error) in
            guard let self = self else { return }
            if let userId = userId {
                let userModel = User(
                    id: userId,
                    fullName: self.fullName,
                    email: self.email
                )
                self.userRepository.insert(user: userModel) { isSuccess in
                    if isSuccess {
                        AppRepository.shared.setCurrentUser(currentUser: userModel)
                        self.output.value = .init(
                            type: .navigation,
                            info: InfoAlertViewModel(title: "Sucesso", message: "Usuário \(userModel.email) criado com sucesso!")
                        )
                    } else {
                        self.output.value = .init(
                            type: .showMessage,
                            info: InfoAlertViewModel(title: "Error", message: "Error ao criar usuário!")
                        )
                    }
                    
                }
            } else if let error = error {
                self.output.value = .init(
                    type: .showMessage,
                    info: InfoAlertViewModel(title: "Error", message: error)
                )
            }
        }
    }
    
}
