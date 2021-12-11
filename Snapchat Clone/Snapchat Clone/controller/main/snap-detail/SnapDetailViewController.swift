//
//  SnapDetailViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 09/12/21.
//

import UIKit

class SnapDetailViewController: UIViewController {
    
    @IBOutlet weak var nextButton: CustomRoundButton!
    @IBOutlet weak var previousButton: CustomRoundButton!
    @IBOutlet weak var snapImageView: UIImageView!
    @IBOutlet weak var snapCountLabel: UILabel!
    @IBOutlet weak var descriptionValueLabel: UILabel!
    var viewModel: SnapDetailViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.bind()
        output.description.bind { [weak self] description in
            self?.descriptionValueLabel.text = description
        }
        
        output.counterText.bind { [weak self] counterText in
            self?.snapCountLabel.text = counterText
        }
        viewModel.loadSnapDetail()
    }
    
    @IBAction func onNextButtonClick(_ sender: CustomRoundButton) {
        viewModel.nextSnap()
    }
    
    @IBAction func onPreviousButtonClick(_ sender: CustomRoundButton) {
        viewModel.previousSnap()
    }
    
    @IBAction func onBackButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
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
