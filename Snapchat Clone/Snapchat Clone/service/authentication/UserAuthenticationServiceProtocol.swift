//
//  UserAuthenticationServiceProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/04/21.
//

import Foundation

protocol UserAuthenticationServiceProtocol {
    
    func create(
        email: String,
        password: String,
        completion: @escaping (String?, String?) -> Void
    )
    
    func signIn(
        email: String,
        password: String,
        completion: @escaping (String?, String?) -> Void
    )
    
    func signOut()
    
    func registerUserAuthenticationState(completion: @escaping (Bool) -> Void)
    
}
