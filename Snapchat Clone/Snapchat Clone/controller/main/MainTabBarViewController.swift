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
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        button.setTitle("Cam", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.setTitleColor(.yellow, for: .highlighted)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 32
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.gray.cgColor
        self.view.insertSubview(button, aboveSubview: self.tabBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 64, height: 64)
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
