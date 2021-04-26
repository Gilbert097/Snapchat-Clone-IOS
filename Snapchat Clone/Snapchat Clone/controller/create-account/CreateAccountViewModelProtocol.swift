//
//  CreateAccountViewProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/04/21.
//

import Foundation

protocol CreateAccountViewModelProtocol{
    
    typealias Input = (
        email: Dynamic<String>,
        password: Dynamic<String>,
        confirmPassword: Dynamic<String>
    )
    
    typealias Output = Dynamic<DynamicData<CreateAccountEventType>>
    
    func bind(input: Input) -> Output
    
    func createAccount()
}
