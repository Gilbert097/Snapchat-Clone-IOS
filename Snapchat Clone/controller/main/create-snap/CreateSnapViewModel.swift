//
//  SnapDetailViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 14/11/21.
//

import Foundation
import FirebaseStorage

class CreateSnapViewModel: CreateSnapViewModelProtocol {
    private static let TAG = "CreateSnapViewModel"
    
    private var imageData: Data? = nil
    private var userSelected: UserItemViewModel? = nil
    private var description: String? = nil
    private let output = Event<EventData<CreateSnapEventType>>(.init(type: .none))
    private let snapRepository: SnapRepositoryProtocol
    
    init( snapRepository: SnapRepositoryProtocol) {
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
            snapRepository.createSnap(
                userTarget: userSelected.id,
                description: self.description ?? "",
                imageData: imageData
            ) { isCreateSnapSuccess in
                    if isCreateSnapSuccess {
                        LogUtils.printMessage(tag: CreateSnapViewModel.TAG, message: "Create snap success!")
                        self.output.value = .init(
                            type: .showMessageSuccess,
                            info: InfoAlertViewModel(title: "Success", message: "Create snap success!")
                        )
                    } else {
                        LogUtils.printMessage(tag: CreateSnapViewModel.TAG, message: "Create snap erro!")
                        self.output.value = .init(
                            type: .showMessageError,
                            info: InfoAlertViewModel(title: "Error", message: "Create snap erro!")
                        )
                    }
                }
            
        }
    }
}
