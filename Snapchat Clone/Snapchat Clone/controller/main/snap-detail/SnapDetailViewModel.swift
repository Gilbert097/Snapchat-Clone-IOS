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
    private var userSelected: UserItemViewModel? = nil
    private var description: String? = nil
    private let output = Event<EventData<SnapDetailEventType>>(.init(type: .none))
    private let mediaService: MediaServiceProtocol
    
    init(mediaService: MediaServiceProtocol) {
        self.mediaService = mediaService
    }
    
    func bind(input: Input) -> Output {
        input.imageData.bind { [weak self] in self?.imageData = $0 }
        input.userSelected.bind { [weak self] in self?.userSelected = $0 }
        input.descriptionSnap.bind { [weak self] in self?.description = $0 }
        return output
    }
    
    func uploadImage() {
        if let imageData = imageData,
           let userSelected = userSelected {
            
            mediaService.uploadImage(path: userSelected.id, imageData: imageData) { [weak self]  isSuccess, mediaMetadata in
                var alertViewModel: InfoAlertViewModel
                if isSuccess {
                    alertViewModel = InfoAlertViewModel(title: "Sucesso", message: "Upload Success!")
                } else {
                    alertViewModel = InfoAlertViewModel(title: "Error", message: "Upload Error!")
                }
                self?.output.value =  .init(type: .showMessageUploadImage, info: alertViewModel)
            }
        }
    }
}
