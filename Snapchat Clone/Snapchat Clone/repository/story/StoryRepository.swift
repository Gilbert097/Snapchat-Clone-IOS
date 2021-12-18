//
//  StoryRepository.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 18/12/21.
//

import Foundation
import FirebaseDatabase

class StoryRepository: StoryRepositoryProtocol {
    
    let database: DatabaseReference
    private static let TAG = "StoryRepository"
    private let mediaService: MediaServiceProtocol
    
    init(mediaService: MediaServiceProtocol) {
        self.mediaService = mediaService
        database = Database.database().reference()
    }
    
    func createStory(
        imageData: Data,
        completion: @escaping (Bool) -> Void
    ) {
        mediaService.uploadImage(userId: nil, imageData: imageData) { [weak self]  isSuccess, mediaMetadata in
            guard let self = self else { return }
            
            if isSuccess,
               let mediaMetadata = mediaMetadata,
               let userSource = AppRepository.shared.currentUser {
                LogUtils.printMessage(tag: StoryRepository.TAG, message: "Upload image success!")
                let story = Story(
                    id: UUID().uuidString,
                    from: userSource.email,
                    nameUser: userSource.fullName,
                    urlImage: mediaMetadata.url,
                    nameImage: mediaMetadata.name,
                    createDate: Int(Date().timeIntervalSince1970),
                    status: .pending
                )
                
                LogUtils.printMessage(tag: StoryRepository.TAG, message: "Story -> \(story.toString())")
                self.insert(story: story) { isStorySuccess in
                    story.status = isStorySuccess ? .created : .error
                    completion(isStorySuccess)
                }
            } else {
                LogUtils.printMessage(tag: StoryRepository.TAG, message: "Upload image error!")
                completion(false)
            }
        }
    }
    
    private func insert(
        story: Story,
        completion: @escaping (Bool) -> Void
    ) {
        LogUtils.printMessage(tag: StoryRepository.TAG, message: "----> Start Insert Story <----")
        database.child("storys")
            .child(story.id)
            .setValue(story.toDictionary()) { error, _ in
                let isSuccess = error == nil
                if isSuccess {
                    LogUtils.printMessage(tag: StoryRepository.TAG, message: "Insert Story Success!")
                } else {
                    LogUtils.printMessage(
                        tag: StoryRepository.TAG,
                        message: "Insert Story Error -> \(String(describing: error?.localizedDescription))"
                    )
                }
                LogUtils.printMessage(tag: StoryRepository.TAG, message: "----> Finish Insert Story <----")
                completion(isSuccess)
            }
    }
}
