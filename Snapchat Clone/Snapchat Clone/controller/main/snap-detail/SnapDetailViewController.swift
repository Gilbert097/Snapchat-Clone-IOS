//
//  SnapDetailViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 12/10/21.
//

import UIKit
import FittedSheets

class SnapDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private static let TAG = "SnapDetailViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var nextButton: RoundButton!
    
    var viewModel: SnapDetailViewModelProtocol!
    private var imagePickerViewController = UIImagePickerController()
    private let input: SnapDetailViewModelProtocol.Input = (
        userSelected: .init(nil),
        imageData: .init(nil),
        descriptionSnap: .init(nil)
    )
    
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
        let output = viewModel.bind(input: input)
        output.bind { [weak self] (dynamicData) in
            
            guard
                let self = self,
                let alertViewModel = dynamicData.info as? InfoAlertViewModel
            else {
                LogUtils.printMessage(tag: SnapDetailViewController.TAG, message: "Error -> Bind values ​​are null!")
                return
            }
            
            switch dynamicData.type {
            case .showMessageError:
                self.updateNextButton(title: "Próximo")
                AlertHelper.shared.showMessage(viewController: self, alertViewModel: alertViewModel)
                return
            case .showMessageSuccess:
                AlertHelper.shared.showMessage(viewController: self, alertViewModel: alertViewModel) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                return
            default:
                LogUtils.printMessage(tag: SnapDetailViewController.TAG, message: "Error -> Event not implemented!")
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
        imagePickerViewController.sourceType = .savedPhotosAlbum
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func onNextButtonClick(_ sender: RoundButton) {
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainstoryboard.instantiateViewController(withIdentifier: "UserListTableViewController") as! UserListTableViewController
        let userListViewModel = UserListTableViewModel(repository: UserRepository())
        controller.viewModel = userListViewModel
        let sheetController = SheetViewController(controller: controller, sizes: [ .fixed(300)])
        
        let output = userListViewModel.bind()
        output.userSelected.bind { [weak self] user in
            guard let self = self else { return }
            print("SnapDetailViewController -> User Selected: \(String(describing: user?.fullName))")
            self.updateNextButton(isEnabled: false, title:"Carregando...")
            
            if let imageSelected = self.imageView.image,
               let imageData = imageSelected.jpegData(compressionQuality: 0.5) {
                self.input.descriptionSnap.value = self.descriptionTextField.text
                self.input.userSelected.value = user
                self.input.imageData.value = imageData
                self.viewModel.uploadImage()
            }else{
                self.updateNextButton(title: "Próximo")
            }
        }
        
        self.present(sheetController, animated: true, completion: nil)
    }
    
    private func updateNextButton(isEnabled: Bool = true, title: String){
        self.nextButton.isEnabled = true
        self.nextButton.setTitle(title, for: .normal)
    }
    
    @IBAction func onBackButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
