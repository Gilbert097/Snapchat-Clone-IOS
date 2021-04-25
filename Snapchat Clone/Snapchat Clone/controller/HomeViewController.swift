//
//  ViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 23/04/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard
            let navigationController = self.navigationController
        else { return }
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let identifier = segue.identifier else { return }
        
        if identifier == "loginSegue",
           let loginViewController = segue.destination as? LoginViewController {
            loginViewController.viewModel = LoginViewModel()
        }else if identifier == "createAccountSegue",
                 let createAccountViewController = segue.destination as? CreateAccountViewController {
            createAccountViewController.viewModel = CreateAccountViewModel()
        }
        
    }
    
}

