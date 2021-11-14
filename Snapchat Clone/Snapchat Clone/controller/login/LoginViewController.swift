//
//  LoginViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 23/04/21.
//

import UIKit
import MaterialComponents.MDCFilledTextField

public class LoginViewController: HomeNavigationBaseViewController {
    
    @IBOutlet weak var emailTextField: MDCFilledTextField!
    @IBOutlet weak var passwordTextField: MDCFilledTextField!
    private let input: LoginViewModelProtocol.Input = (
        email: Dynamic<String>(""),
        password: Dynamic<String>("")
    )
    
    var viewModel: LoginViewModelProtocol!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureFilledTextField(textField: emailTextField)
        configureFilledTextField(textField: passwordTextField)
        configureBind()
    }
    
    private func configureBind(){
        let output = viewModel.bind(input: input)
        output.bind { dynamicData in
            switch dynamicData.type {
            case .showMessage:
                guard let alertViewModel = dynamicData.info as? InfoAlertViewModel else { return }
                AlertHelper.shared.showMessage(viewController: self, alertViewModel: alertViewModel)
            case .navigationToMain:
                self.performSegue(withIdentifier: "loginToMainSegue", sender: nil)
            case .none:
                return
            }
        }
    }
    
    @IBAction func loginButtonClick(_ sender: RoundButton) {
        input.email.value = emailTextField.text!
        input.password.value = passwordTextField.text!
        viewModel.login()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
