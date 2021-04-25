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
        configureBind()
    }
    
    private func configureBind(){
        let output = viewModel.bind(input: input)
        output.bind { (eventType) in
            print("output: \(eventType)")
        }
    }
    
    @IBAction func createButtonClick(_ sender: Any) {
        input.email.value = emailTextField.text!
        input.password.value = passwordTextField.text!
        input.confirmPassword.value = confirmPasswordTextField.text!
        viewModel.createAccount()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
