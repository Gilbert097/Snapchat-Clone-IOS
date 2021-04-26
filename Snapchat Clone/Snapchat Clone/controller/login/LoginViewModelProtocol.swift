//
//  LoginViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/04/21.
//

import Foundation

protocol LoginViewModelProtocol {
    
    typealias Input = (email: Dynamic<String>, password: Dynamic<String>)
    typealias Output = Dynamic<DynamicData<LoginEventType>>
    
    func bind(input: Input) -> Output
    func login()
}
