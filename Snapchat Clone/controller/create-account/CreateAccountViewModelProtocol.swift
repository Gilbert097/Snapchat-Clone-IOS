//
//  CreateAccountViewProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/04/21.
//

import Foundation

protocol CreateAccountViewModelProtocol{
    
    typealias Input = (
        fullName: Event<String>,
        email: Event<String>,
        password: Event<String>,
        confirmPassword: Event<String>
    )
    
    typealias Output = Event<EventData<CreateAccountEventType>>
    
    func bind(input: Input) -> Output
    
    func createAccount()
}
