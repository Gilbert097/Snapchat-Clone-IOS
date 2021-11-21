//
//  CreateAccountViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 23/04/21.
//

import UIKit
import MaterialComponents.MDCFilledTextField

class CreateAccountViewController: HomeNavigationBaseViewController {
    
    @IBOutlet weak var emailTextField: MDCFilledTextField!
    @IBOutlet weak var passwordTextField: MDCFilledTextField!
    @IBOutlet weak var confirmPasswordTextField: MDCFilledTextField!
    @IBOutlet weak var fullNameTextField: MDCFilledTextField!
    
    var viewModel: CreateAccountViewModelProtocol!
    private let input: CreateAccountViewModelProtocol.Input = (
        email: Dynamic<String>(""),
        password: Dynamic<String>(""),
        confirmPassword: Dynamic<String>("")
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFilledTextField(textField: emailTextField)
        configureFilledTextField(textField: passwordTextField)
        configureFilledTextField(textField: confirmPasswordTextField)
        configureFilledTextField(textField: fullNameTextField)
        configureBind()
    }
    
    private func configureBind(){
        let output = viewModel.bind(input: input)
        output.bind { (dynamicData) in
            switch dynamicData.type {
            case .showMessage:
                guard let alertViewModel = dynamicData.info as? InfoAlertViewModel else { return }
                AlertHelper.shared.showMessage(viewController: self, alertViewModel: alertViewModel)
            case .navigation:
                guard let alertViewModel = dynamicData.info as? InfoAlertViewModel else { return }
                AlertHelper.shared.showMessage(viewController: self, alertViewModel: alertViewModel) {[weak self] action in
                    self?.performSegue(withIdentifier: "createAccountToMainSegue", sender: nil)
                }
            case .none:
                return
            }
        }
    }
    
    @IBAction func createButtonClick(_ sender: Any) {
        input.email.value = emailTextField.text!
        input.password.value = passwordTextField.text!
        input.confirmPassword.value = confirmPasswordTextField.text!
        viewModel.createAccount()
    }
    
}
