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
        fullName: Event<String>(""),
        email: Event<String>(""),
        password: Event<String>(""),
        confirmPassword: Event<String>("")
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFilledTextField(textField: fullNameTextField)
        configureFilledTextField(textField: emailTextField)
        configureFilledTextField(textField: passwordTextField)
        configureFilledTextField(textField: confirmPasswordTextField)
        configureBind()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    @IBAction func onCreateCountButtonClick(_ sender: CustomRoundButton) {
        input.fullName.value = fullNameTextField.text!
        input.email.value = emailTextField.text!
        input.password.value = passwordTextField.text!
        input.confirmPassword.value = confirmPasswordTextField.text!
        viewModel.createAccount()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if passwordTextField.isEditing || confirmPasswordTextField.isEditing {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
