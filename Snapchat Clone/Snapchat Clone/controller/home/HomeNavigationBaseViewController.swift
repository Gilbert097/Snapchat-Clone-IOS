//
//  HomeNavigationBaseViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/04/21.
//

import UIKit
import MaterialComponents.MDCFilledTextField

public class HomeNavigationBaseViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        guard
            let navigationController = self.navigationController
        else { return }
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.backItem?.title = ""
        navigationController.navigationBar.tintColor = UIColor.hexStringToUIColor(hex:  "#8D5EBF")
    }
    
    public func configureFilledTextField(textField: MDCFilledTextField){
        textField.setFilledBackgroundColor(.clear, for: .normal)
        textField.setFilledBackgroundColor(UIColor.white, for: .editing)
        let underlineColor = UIColor.hexStringToUIColor(hex:  "#CCCCCC")
        textField.setUnderlineColor(underlineColor, for: .editing)
        textField.setUnderlineColor(underlineColor, for: .normal)
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
