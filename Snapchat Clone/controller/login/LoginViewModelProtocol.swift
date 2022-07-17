//
//  LoginViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/04/21.
//

import Foundation

protocol LoginViewModelProtocol {
    
    typealias Input = (email: Event<String>, password: Event<String>)
    typealias Output = Event<EventData<LoginEventType>>
    
    func bind(input: Input) -> Output
    func login()
}
