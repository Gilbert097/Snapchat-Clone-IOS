//
//  LoginViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 23/04/21.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard
            let navigationController = self.navigationController
        else { return }
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.backItem?.title = ""
        navigationController.navigationBar.tintColor = UIColor.hexStringToUIColor(hex:  "#98599D")
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
