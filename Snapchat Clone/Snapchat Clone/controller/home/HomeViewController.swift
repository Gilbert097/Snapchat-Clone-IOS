//
//  ViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 23/04/21.
//

import UIKit

private extension String {
    static let homeToCreateAccountSegue = "homeToCreateAccountSegue"
    static let homeToLoginSegue = "homeToLoginSegue"
    static let homeToMainSegue = "homeToMainSegue"
}

class HomeViewController: UIViewController {
    
    var viewModel = HomeViewModel(authenticationService: UserAuthenticationService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBind()
        viewModel.checkUserLogged()
    }
    private func configureBind(){
        let output = viewModel.bind()
        output.bind { (dynamicData) in
            if case .navigationToMain = dynamicData.type {
               self.performSegue(withIdentifier: .homeToMainSegue, sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard
            let navigationController = self.navigationController
        else { return }
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let identifier = segue.identifier else { return }
        
        if identifier == .homeToLoginSegue,
           let loginViewController = segue.destination as? LoginViewController {
            loginViewController.viewModel = LoginViewModel(authenticationService: UserAuthenticationService())
        } else if identifier == .homeToCreateAccountSegue,
                 let createAccountViewController = segue.destination as? CreateAccountViewController {
            createAccountViewController.viewModel = CreateAccountViewModel(authenticationService: UserAuthenticationService())
        }
        
    }
    
}

