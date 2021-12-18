//
//  CreateStoryViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 18/12/21.
//

import Foundation

class CreateStoryViewModel: CreateStoryViewModelProtocol {
    
    private static let TAG = "CreateStoryViewModel"
    private let output = Event<EventData<CreateStoryEventType>>(.init(type: .none))
    private let storyRepository: StoryRepositoryProtocol
    private var imageData: Data? = nil
    
    init(storyRepository: StoryRepositoryProtocol){
        self.storyRepository = storyRepository
    }
    
    func bind(input: Input) -> Output {
        input.bind { [weak self] in self?.imageData = $0 }
        return output
    }
    
    func sendStory() {
        if let imageData = imageData {
            storyRepository.createStory(
                imageData: imageData
            ) { isCreateStorySuccess in
                if isCreateStorySuccess {
                    LogUtils.printMessage(tag: CreateStoryViewModel.TAG, message: "Create story success!")
                    self.output.value = .init(
                        type: .showMessageSuccess,
                        info: InfoAlertViewModel(title: "Success", message: "Create story success!")
                    )
                } else {
                    LogUtils.printMessage(tag: CreateStoryViewModel.TAG, message: "Create story erro!")
                    self.output.value = .init(
                        type: .showMessageError,
                        info: InfoAlertViewModel(title: "Error", message: "Create story erro!")
                    )
                }
            }
        }
    }
}
