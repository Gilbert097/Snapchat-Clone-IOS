//
//  UserAuthenticationServiceProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/04/21.
//

import Foundation

protocol UserAuthenticationServiceProtocol {
    
    func createUserAuthentication(
        email: String,
        password: String,
        completion: @escaping (UserAuthentication?, String?) -> Void
    )
    
    func signIn(
        email: String,
        password: String,
        completion: @escaping (UserAuthentication?, String?) -> Void
    )
    
    func signOut()
    
    func getUserAuthenticationState(completion: @escaping (Bool) -> Void)
    
}
