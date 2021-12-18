//
//  CreateStoryViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 18/12/21.
//

import UIKit

class CreateStoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private static let TAG = "CreateStoryViewController"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: CustomRoundButton!
    @IBOutlet weak var sendButton: CustomRoundButton!
    var viewModel: CreateStoryViewModelProtocol!
    private var imagePickerViewController = UIImagePickerController()
    private let input: CreateStoryViewModelProtocol.Input = Event<Data?>(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerViewController.delegate = self
        configureBind()
    }
    
    private func configureBind() {
        let output = viewModel.bind(input: input)
        output.bind { [weak self] (dynamicData) in
            
            guard
                let self = self,
                let alertViewModel = dynamicData.info as? InfoAlertViewModel
            else {
                LogUtils.printMessage(tag: CreateStoryViewController.TAG, message: "Error -> Bind values ​​are null!")
                return
            }
            
            switch dynamicData.type {
            case .showMessageError:
                AlertHelper.shared.showMessage(viewController: self, alertViewModel: alertViewModel)
                return
            case .showMessageSuccess:
                AlertHelper.shared.showMessage(viewController: self, alertViewModel: alertViewModel) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                return
            default:
                LogUtils.printMessage(tag: CreateStoryViewController.TAG, message: "Error -> Event not implemented!")
                return
            }
        }
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = originalImage
        self.sendButton.isHidden = false
        imagePickerViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCloseButtonClick(_ sender: CustomRoundButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onCameraButtonClick(_ sender: CustomRoundButton) {
        imagePickerViewController.sourceType = .savedPhotosAlbum
        present(imagePickerViewController, animated: true, completion: nil)
    }
    @IBAction func onSendButtonClick(_ sender: CustomRoundButton) {
        if let imageSelected = self.imageView.image,
           let imageData = imageSelected.jpegData(compressionQuality: 0.5) {
            input.value = imageData
            viewModel.sendStory()
        }
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
