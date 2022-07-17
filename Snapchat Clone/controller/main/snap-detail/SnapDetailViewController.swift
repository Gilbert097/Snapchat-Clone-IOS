//
//  SnapDetailViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 09/12/21.
//

import UIKit
import SDWebImage

class SnapDetailViewController: UIViewController {
    private static let TAG = "SnapDetailViewController"
    
    @IBOutlet weak var nextButton: CustomRoundButton!
    @IBOutlet weak var previousButton: CustomRoundButton!
    @IBOutlet weak var snapImageView: UIImageView!
    @IBOutlet weak var snapCountLabel: UILabel!
    @IBOutlet weak var descriptionValueLabel: UILabel!
    var viewModel: SnapDetailViewModelProtocol!
    private let input: SnapDetailViewModelProtocol.Input = Event<Bool>(false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.bind(input: input)
        output.description.bind { [weak self] description in
            self?.descriptionValueLabel.text = description
        }
        
        output.counterText.bind { [weak self] counterText in
            self?.snapCountLabel.text = counterText
        }
        
        output.isNextButtonVisible.bind { [weak self] isNextButtonVisible in
            self?.nextButton.isHidden = !isNextButtonVisible
        }
        
        output.isPreviousButtonVisible.bindAndFire { [weak self] isPreviousButtonVisible in
            self?.previousButton.isHidden = !isPreviousButtonVisible
        }
        
        output.isCounterTextVisible.bind { [weak self] isCounterTextVisible in
            self?.snapCountLabel.isHidden = !isCounterTextVisible
        }
        
        output.urlImage.bind { [weak self] urlImage in
            LogUtils.printMessage(tag: SnapDetailViewController.TAG, message: "Url image received -> \(urlImage)")
            LogUtils.printMessage(tag: SnapDetailViewController.TAG, message: "------> Start Download Image <------")
            self?.snapImageView.sd_setImage(with: URL(string: urlImage)) { image, error, cacheType, url in
                if let error = error {
                    LogUtils.printMessage(tag: SnapDetailViewController.TAG, message: "Download image error -> \(error.localizedDescription)")
                    self?.input.value = false
                } else {
                    LogUtils.printMessage(tag: SnapDetailViewController.TAG, message: "Download image success!")
                    self?.input.value = true
                }
                LogUtils.printMessage(tag: SnapDetailViewController.TAG, message: "------> Finish Download Image <------")
            }
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
