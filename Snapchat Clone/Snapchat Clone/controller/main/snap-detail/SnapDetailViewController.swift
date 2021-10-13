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
    
    private var imagePickerViewController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerViewController.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = originalImage
        imagePickerViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCameraButtonClick(_ sender: UIBarButtonItem) {
        imagePickerViewController.sourceType = .savedPhotosAlbum
        
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func onBackButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
