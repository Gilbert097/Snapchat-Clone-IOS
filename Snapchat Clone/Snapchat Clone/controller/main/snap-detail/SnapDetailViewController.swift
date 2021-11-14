//
//  SnapDetailViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 12/10/21.
//

import UIKit
import FirebaseStorage

class SnapDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var nextButton: RoundButton!
    
    private var imagePickerViewController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerViewController.delegate = self
        self.nextButton.isEnabled = false
        self.nextButton.backgroundColor = .gray
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        imagePickerViewController.sourceType = .savedPhotosAlbum
        
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func onNextButtonClick(_ sender: RoundButton) {
        nextButton.isEnabled = false
        nextButton.setTitle("Carregando...", for: .normal)
        
        let storage = Storage.storage().reference()
        let imagePath = storage.child("imagens")
        
        if let imageSelected = imageView.image,
           let imageData = imageSelected.jpegData(compressionQuality: 0.5) {
            let imageId = NSUUID().uuidString
            imagePath.child("\(imageId).jpg").putData(imageData, metadata: nil) { metadata, error in
                if error == nil {
                    print("Upload Success!")
                } else {
                    print("Upload Error!")
                }
                self.nextButton.isEnabled = true
                self.nextButton.setTitle("Próximo", for: .normal)
            }
        }
        
    }
    
    @IBAction func onBackButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
