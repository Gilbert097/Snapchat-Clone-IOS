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
    private var userSelected: User? = nil
    private var description: String? = nil
    private let output = Dynamic<DynamicData<SnapDetailEventType>>(.init(type: .none))
    private let mediaService: MediaServiceProtocol
    
    init(mediaService: MediaServiceProtocol) {
        self.mediaService = mediaService
    }
    
    func bind(input: Input) -> Output {
        input.imageData.bind { self.imageData = $0 }
        input.userSelected.bind { self.userSelected = $0 }
        input.descriptionSnap.bind { self.description = $0 }
        return output
    }
    
    func uploadImage() {
        if let imageData = imageData,
           let userSelected = userSelected{
            
            mediaService.uploadImage(path: userSelected.id, imageData: imageData) { isSuccess, mediaMetadata in
                var alertViewModel: InfoAlertViewModel
                if isSuccess {
                    alertViewModel = InfoAlertViewModel(title: "Sucesso", message: "Upload Success!")
                } else {
                    alertViewModel = InfoAlertViewModel(title: "Error", message: "Upload Error!")
                }
                self.output.value =  .init(type: .showMessageUploadImage, info: alertViewModel)
            }
        }
    }
}
