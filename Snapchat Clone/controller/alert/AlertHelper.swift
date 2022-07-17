//
//  AlertHelper.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/04/21.
//

import Foundation
import UIKit

struct AlertHelper {
    static let shared = AlertHelper()
    private init() { }
    
    func showMessage(viewController:UIViewController, alertViewModel: InfoAlertViewModel, handler: ((UIAlertAction) -> Void)? = nil){
        let alertViewController = UIAlertController(title: alertViewModel.title, message: alertViewModel.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alertViewController.addAction(okAction)
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
}
