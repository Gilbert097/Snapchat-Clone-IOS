//
//  UserAuthenticationService.swift
//  Firebase Aula
//
//  Created by Gilberto Silva on 15/04/21.
//

import Foundation
import Firebase
import UIKit
import FirebaseAuth

private extension String {
    static let operationNotAllowed = "Administrador desabilitou o logon com o provedor de identidade especificado."
    static let emailAlreadyInUse = "E-mail usado para tentar uma inscrição já está em uso."
    static let invalidEmail = "E-mail é inválido."
    static let weakPassword = "Senha considerada muito fraca."
    static let createUserError = "Erro ao tentar criar usuário."
    static let loginUserError = "Erro ao tentar efeutar login."
}

public class UserAuthenticationService: UserAuthenticationServiceProtocol {
    
    private static let TAG = "UserAuthenticationService"
    private var handlers: [AuthStateDidChangeListenerHandle] = []
    
    private enum Action{
        case signIn
        case createUser
    }
    
    public func create(
        email: String,
        password: String,
        completion: @escaping (String?, String?) -> Void
    ) {
        LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "----> Start Create User <----")
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] (authDataResult: AuthDataResult?, error: Error?) in
            guard let self = self else { return }
            
            if let authDataResult = authDataResult {
                LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "Create User Success!")
                completion(authDataResult.user.uid, nil)
            } else if let error = error {
                LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "Create User Error -> \(error.localizedDescription)")
                self.notifyError(action: .createUser, authDataError: error, completion: completion)
            }
            LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "----> Finish Create User <----")
        }
    }
    
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (String?, String?) -> Void
    ){
        LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "----> Start SignIn <----")
        Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] (authDataResult: AuthDataResult?, error: Error?) in
            
            guard let self = self else { return }
            
            if let authDataResult = authDataResult {
                LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "SignIn Success!")
                completion(authDataResult.user.uid, nil)
            } else if let error = error {
                LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "SignIn Error -> \(error.localizedDescription)")
                self.notifyError(action: .signIn, authDataError: error, completion: completion)
            }
            LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "----> Finish SignIn <----")
        }
    }
    
    public func signOut(){
        do {
            try Auth.auth().signOut()
        } catch {
            LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "SignOut Error -> \(error.localizedDescription)")
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
    
    private func getAuthenticationErrorMessage(error: NSError) -> String {
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
    
    public func registerUserAuthenticationState(completion: @escaping (String?) -> Void) {
        LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "----> Add state did change listener <----")
        let handle = Auth.auth().addStateDidChangeListener { (firAuth, user) in
            LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "----> Received state did change <----")
            if let user = user{
                LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "User logged \(String(describing: user.email)).")
                completion(user.uid)
            } else {
                LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "No users logged in!")
                completion(nil)
            }
        }
        handlers.append(handle)
    }
    
    public func removeUserAuthenticationState(){
        handlers.forEach { handler in
            LogUtils.printMessage(tag: UserAuthenticationService.TAG, message: "----> Remove state did change listener <----")
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
}
