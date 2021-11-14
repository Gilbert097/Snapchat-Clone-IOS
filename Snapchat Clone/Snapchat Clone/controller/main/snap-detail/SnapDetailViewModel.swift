//
//  SnapDetailViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 14/11/21.
//

import Foundation
import FirebaseStorage

class SnapDetailViewModel: SnapDetailViewModelProtocol {
    private var imageData: Data? = nil
    private let output = Dynamic<DynamicData<SnapDetailEventType>>(.init(type: .none))
    
    func bind(imageData: Dynamic<Data?>) -> Output {
        imageData.bind { self.imageData = $0 }
        return output
    }
    
    func uploadImage() {
        if let imageData = imageData {
            let storage = Storage.storage().reference()
            let imagePath = storage.child("imagens")
            
            let imageId = NSUUID().uuidString
            imagePath.child("\(imageId).jpg").putData(imageData, metadata: nil) { metadata, error in
                var alertViewModel: InfoAlertViewModel
                if error == nil {
                    alertViewModel = InfoAlertViewModel(title: "Sucesso", message: "Upload Success!")
                    print("Path: \(String(describing: metadata?.path))")
                } else {
                    alertViewModel = InfoAlertViewModel(title: "Error", message: error?.localizedDescription ?? "Upload Error!")
                }
                
                self.output.value =  .init(type: .showMessageUploadImage, info: alertViewModel)
                
            }
        }
        
    }
    
    
    
}
