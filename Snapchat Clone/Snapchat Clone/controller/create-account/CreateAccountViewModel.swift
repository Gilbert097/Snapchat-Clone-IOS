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
    private let output = Dynamic<CreateAccountEventType>(.none)
    
    func bind(input: Input) -> Output {
        
        input.email.bind{
            print("email changed")
            self.email = $0
        }
        input.password.bind{ self.password = $0 }
        input.confirmPassword.bind{ self.confirmPassword = $0 }
        
       return output
    }
    
    func createAccount() {
        print("email: \(email), password: \(password), confirmPassword: \(confirmPassword)")
        output.value = .showMessage
    }
    
}
