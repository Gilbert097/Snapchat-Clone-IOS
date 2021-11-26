//
//  OptionsViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/11/21.
//

import UIKit

class MediaOptionsViewController: UIViewController {
    
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var publishLabel: UILabel!
    var viewModel: MediaOptionsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.storyLabelTap))
        storyLabel.isUserInteractionEnabled = true
        storyLabel.addGestureRecognizer(storyTapGesture)
        
        let publishTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.publishLabelTap))
        publishLabel.isUserInteractionEnabled = true
        publishLabel.addGestureRecognizer(publishTapGesture)
    }
    
    @objc
    func storyLabelTap(sender:UITapGestureRecognizer) {
        viewModel.createMedia(type: .story)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func publishLabelTap(sender:UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: {
            self.viewModel.createMedia(type: .publish)
        })
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
