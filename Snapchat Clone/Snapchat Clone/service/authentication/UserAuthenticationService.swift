//
//  UserAuthenticationService.swift
//  Firebase Aula
//
//  Created by Gilberto Silva on 15/04/21.
//

import Foundation
import Firebase

private extension String {
    static let operationNotAllowed = "Administrador desabilitou o logon com o provedor de identidade especificado."
    static let emailAlreadyInUse = "E-mail usado para tentar uma inscrição já está em uso."
    static let invalidEmail = "E-mail é inválido."
    static let weakPassword = "Senha considerada muito fraca."
    static let createUserError = "Erro ao tentar criar usuário."
    static let loginUserError = "Erro ao tentar efeutar login."
}

public class UserAuthenticationService: UserAuthenticationServiceProtocol {
    
    private enum Action{
        case signIn
        case createUser
    }
    
    public func create(
        email: String,
        password: String,
        completion: @escaping (String?, String?) -> Void
    ){
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] (authDataResult: AuthDataResult?, error: Error?) in
            guard let self = self else { return }
            
            self.notify(
                action: .signIn,
                authDataResult: authDataResult,
                error: error,
                completion: completion
            )
        }
    }
    
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (String?, String?) -> Void
    ){
        Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] (authDataResult: AuthDataResult?, error: Error?) in
            guard let self = self else { return }
            
            self.notify(
                action: .signIn,
                authDataResult: authDataResult,
                error: error,
                completion: completion
            )
        }
    }
    
    public func signOut(){
        do {
            try Auth.auth().signOut()
        } catch {
            print("SignOut Error: \(error.localizedDescription)")
        }
    }
    
    private func notify(
        action: Action,
        authDataResult: AuthDataResult?,
        error: Error?,
        completion: @escaping (String?, String?) -> Void
    ) {
        if let authDataResult = authDataResult {
            completion(authDataResult.user.uid, nil)
        } else if let error = error {
            notifyError(action: action, authDataError: error, completion: completion)
        }
    }
    
    private func notifyError(
        action: Action,
        authDataError: Error?,
        completion: @escaping (String?, String?) -> Void
    ){
        guard
            let errorParse = authDataError as NSError?
        else {
            let message = getDefaultMessageErrorByAction(action: action)
            completion(nil, message)
            return
        }
        let errorMessage = self.getAuthenticationErrorMessage(error: errorParse)
        completion(nil, errorMessage)
    }
    
    private func getDefaultMessageErrorByAction(action: Action) -> String {
        switch action {
        case .signIn:
            return .loginUserError
        case .createUser:
            return .createUserError
        }
    }
    
    private func getAuthenticationErrorMessage(error: NSError) -> String
    {
        switch AuthErrorCode(rawValue: error.code) {
        case .operationNotAllowed:
            return .operationNotAllowed
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .invalidEmail:
            return .invalidEmail
        case .weakPassword:
            return .weakPassword
        default:
            return "Error: \(error.localizedDescription)"
        }
    }
    
    public func registerUserAuthenticationState(completion: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener { (firAuth, user) in
            var isUserLogged = false
            if let user = user, let email = user.email {
                isUserLogged = true
                print("Usuário logado \(String(describing: email)).")
            } else {
                isUserLogged = false
                print("Nenhum usuário logado!")
            }
            completion(isUserLogged)
        }
    }
    
}
