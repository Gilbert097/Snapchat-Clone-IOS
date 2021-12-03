//
//  SnapDetailViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 14/11/21.
//

import Foundation
import FirebaseStorage

class SnapDetailViewModel: SnapDetailViewModelProtocol {
    private static let TAG = "SnapDetailViewModel"
    
    private var imageData: Data? = nil
    private var userSelected: UserItemViewModel? = nil
    private var description: String? = nil
    private let output = Event<EventData<SnapDetailEventType>>(.init(type: .none))
    private let mediaService: MediaServiceProtocol
    private let snapRepository: SnapRepositoryProtocol
    
    init(
        mediaService: MediaServiceProtocol,
        snapRepository: SnapRepositoryProtocol
    ) {
        self.mediaService = mediaService
        self.snapRepository = snapRepository
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
                guard let self = self else { return }
                
                if isSuccess,
                    let mediaMetadata = mediaMetadata,
                    let userSource = AppRepository.shared.currentUser {
                    
                    let snap = Snap(
                        id: UUID().uuidString,
                        from: userSource.email,
                        nameUser: userSource.fullName,
                        description: self.description ?? "",
                        urlImage: mediaMetadata.url,
                        nameImage: mediaMetadata.name
                    )
                    LogUtils.printMessage(tag: SnapDetailViewModel.TAG, message: "Snap -> \(snap.toString())")
                    self.snapRepository.insert(userIdTarget: userSelected.id, snap: snap) { isSnapSuccess in
                        let alertViewModel: InfoAlertViewModel
                        if isSnapSuccess {
                            alertViewModel = InfoAlertViewModel(title: "Success", message: "Create snap success!")
                        } else {
                            alertViewModel = InfoAlertViewModel(title: "Error", message: "Create snap erro!")
                        }
                        self.output.value = .init(type: .showMessageUploadImage, info: alertViewModel)
                    }
                    
                } else {
                    self.output.value = .init(
                        type: .showMessageUploadImage,
                        info: InfoAlertViewModel(title: "Error", message: "Upload Media Error!")
                    )
                }
               
            }
        }
    }
}
