//
//  MainTabBarViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/04/21.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    let button = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabs()
        configButtonCustom()
    }
    
    private func configTabs() {
        if let last = self.viewControllers?.last, last is UINavigationController{
            let nv = last as! UINavigationController
            
            if let nvLast = nv.viewControllers.last, nvLast is SnapListTabViewController {
                let snapListViewController = nvLast as! SnapListTabViewController
                snapListViewController.viewModel = SnapListViewModel(authenticationService: UserAuthenticationService())
            }
        }
    }
    
    private func configButtonCustom() {
        //        button.setTitle("Cam", for: .normal)
        //        button.setTitleColor(.black, for: .normal)
        //        button.setTitleColor(.yellow, for: .highlighted)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 32
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(onButtonCustomClick), for: .touchUpInside)
        self.view.insertSubview(button, aboveSubview: self.tabBar)
    }
    
    @objc func onButtonCustomClick(sender: UIButton!) {
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let snapDetailViewController = mainstoryboard.instantiateViewController(withIdentifier: "SnapDetailNavigation") as! UINavigationController
        present(snapDetailViewController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 64, height: 64)
    }
    
}
