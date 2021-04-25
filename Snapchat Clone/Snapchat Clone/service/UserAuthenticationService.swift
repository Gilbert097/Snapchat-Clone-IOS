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

public class UserAuthenticationService {
    
    typealias AuthDataError = (error: Error?, action: AuthenticationAction)
    
    enum AuthenticationAction{
        case signIn
        case createUser
    }
    
    static let shared = UserAuthenticationService()
    private(set) var isUserLogged = false
    
    private init(){
        registerUserAuthenticationStateListner()
    }
    
    public func createUserAuthentication(
        email: String,
        password: String,
        completion: @escaping (UserAuthentication?, String?) -> Void
    ){
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] (authDataResult: AuthDataResult?, error: Error?) in
            guard let self = self else { return }
            let authDataError: AuthDataError? = error != nil ? (error, .createUser) : nil
            self.notifyUserAuthentication(authDataResult: authDataResult, authDataError: authDataError, completion: completion)
        }
    }
    
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (UserAuthentication?, String?) -> Void
    ){
        Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] (authDataResult: AuthDataResult?, error: Error?) in
            guard let self = self else { return }
            let authDataError: AuthDataError? = error != nil ? (error, .signIn) : nil
            self.notifyUserAuthentication(authDataResult: authDataResult, authDataError: authDataError, completion: completion)
        }
    }
    
    public func signOut(){
        do {
            try Auth.auth().signOut()
        } catch {
            print("SignOut Error: \(error.localizedDescription)")
        }
    }
    
    private func notifyUserAuthentication(
        authDataResult: AuthDataResult?,
        authDataError: AuthDataError?,
        completion: @escaping (UserAuthentication?, String?) -> Void
    ) {
        if let authDataResult = authDataResult {
            notifyUserAuthenticationSuccess(authDataResult: authDataResult, completion: completion)
        } else if  let authDataError = authDataError {
            notifyUserAuthenticationError(authDataError: authDataError, completion: completion)
        }
    }
    
    private func notifyUserAuthenticationSuccess(
        authDataResult: AuthDataResult,
        completion: @escaping (UserAuthentication?, String?) -> Void
    ) {
        let id = authDataResult.user.uid
        let email = authDataResult.user.email ?? ""
        completion(UserAuthentication(uid: id, email: email), nil)
    }
    
    private func notifyUserAuthenticationError(
        authDataError: AuthDataError,
        completion: @escaping (UserAuthentication?, String?) -> Void
    ){
        guard
            let errorParse = authDataError.error as NSError?
        else {
            let message = getDefaultMessageErrorByAction(action: authDataError.action)
            completion(nil, message)
            return
        }
        let errorMessage = self.getAuthenticationErrorMessage(error: errorParse)
        completion(nil, errorMessage)
    }
    
    private func getDefaultMessageErrorByAction(action: AuthenticationAction) -> String {
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
    
    private func registerUserAuthenticationStateListner() {
        Auth.auth().addStateDidChangeListener { [weak self] (firAuth, user) in
            guard let self = self else { return }
            if let user = user, let email = user.email {
                self.isUserLogged = true
                print("Usuário logado \(String(describing: email)).")
            }else{
                self.isUserLogged = false
                print("Nenhum usuário logado!")
            }
        }
    }
    
}
