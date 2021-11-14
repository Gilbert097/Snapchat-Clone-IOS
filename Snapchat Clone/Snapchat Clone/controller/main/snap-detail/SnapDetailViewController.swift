//
//  SnapDetailViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 12/10/21.
//

import UIKit


class SnapDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var nextButton: RoundButton!
    
    var viewModel: SnapDetailViewModelProtocol!
    private var imagePickerViewController = UIImagePickerController()
    private var imageData = Dynamic<Data?>(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerViewController.delegate = self
        self.nextButton.isEnabled = false
        self.nextButton.backgroundColor = .gray
        self.configureBind()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureBind(){
        let output = viewModel.bind(imageData: imageData)
        output.bind { (dynamicData) in
            switch dynamicData.type {
            case .showMessageUploadImage:
                guard let alertViewModel = dynamicData.info as? InfoAlertViewModel else { return }
                self.updateNextButton(title: "Próximo")
                AlertHelper.shared.showMessage(viewController: self, alertViewModel: alertViewModel)
                return
            case .none:
                return
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = originalImage
        self.nextButton.isEnabled = true
        self.nextButton.backgroundColor = UIColor.hexStringToUIColor(hex:  "#98599D")
        
        imagePickerViewController.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func onCameraButtonClick(_ sender: UIBarButtonItem) {
        imagePickerViewController.sourceType = .camera
        
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func onNextButtonClick(_ sender: RoundButton) {
        updateNextButton(isEnabled: false, title:"Carregando...")
        
        if let imageSelected = imageView.image,
           let imageData = imageSelected.jpegData(compressionQuality: 0.5) {
            
            self.imageData.value = imageData
            viewModel.uploadImage()
        }else{
            updateNextButton(title: "Próximo")
        }
    }
    
    private func updateNextButton(isEnabled: Bool = true, title: String){
        self.nextButton.isEnabled = true
        self.nextButton.setTitle(title, for: .normal)
    }
    
    @IBAction func onBackButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
