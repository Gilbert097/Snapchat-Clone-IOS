//
//  MainTabBarViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/04/21.
//

import UIKit
import FittedSheets

class MainTabBarViewController: UITabBarController {
    let button = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabs()
        configButtonCustom()
    }
    
    private func configTabs() {
        if let first = self.viewControllers?.first, first is UINavigationController{
            let nv = first as! UINavigationController
            
            if let nvFirst = nv.viewControllers.last, nvFirst is SnapListTabViewController {
                let snapListViewController = nvFirst as! SnapListTabViewController
                snapListViewController.viewModel = SnapListViewModel(
                    authenticationService: UserAuthenticationService(),
                    snapRepository: SnapRepository(mediaService: MediaService())
                )
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
        let controller = mainstoryboard.instantiateViewController(withIdentifier: "OptionsViewController") as! MediaOptionsViewController
        let mediaOptionsViewModel = MediaOptionsViewModel()
        controller.viewModel = mediaOptionsViewModel
        let sheetController = SheetViewController(controller: controller, sizes: [ .fixed(150)])
        bindMediaOptionsViewModel(mediaOptionsViewModel)
        self.present(sheetController, animated: true, completion: nil)
    }
    
    private func bindMediaOptionsViewModel(_ mediaOptionsViewModel: MediaOptionsViewModel) {
        let output = mediaOptionsViewModel.bind()
        output.bind { event in
            switch(event){
            case .createStory:
                self.navigateCreateStoryController()
                break
            case .createSnap:
                self.navigateCreateSnapController()
                break
            case .none:
                break
            }
        }
    }
    
    private func navigateCreateStoryController() {
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let createStoryViewController = mainstoryboard.instantiateViewController(withIdentifier: "CreateStoryViewController") as! CreateStoryViewController
        createStoryViewController.viewModel = CreateStoryViewModel()
        self.present(createStoryViewController, animated: true, completion: nil)
    }
    
    private func navigateCreateSnapController() {
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let snapDetailNavigation = mainstoryboard.instantiateViewController(withIdentifier: "SnapDetailNavigation") as! UINavigationController
        let snapDetailViewController = snapDetailNavigation.viewControllers.first as! CreateSnapViewController
        snapDetailViewController.viewModel = CreateSnapViewModel(
            snapRepository: SnapRepository(mediaService: MediaService())
        )
        self.present(snapDetailNavigation, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 64, height: 64)
    }
    
}
