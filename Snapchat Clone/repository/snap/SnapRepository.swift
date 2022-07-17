//
//  SnapRepository.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 02/12/21.
//

import Foundation
import FirebaseDatabase

class SnapRepository: SnapRepositoryProtocol {
    
    let database: DatabaseReference
    private static let TAG = "SnapRepository"
    private let mediaService: MediaServiceProtocol
    
    init(mediaService: MediaServiceProtocol) {
        self.mediaService = mediaService
        database = Database.database().reference()
    }
    
    func createSnap(
        userTarget: String,
        description: String,
        imageData: Data,
        completion: @escaping (Bool) -> Void
    ){
        mediaService.uploadImage(userId: userTarget, imageData: imageData) { [weak self]  isSuccess, mediaMetadata in
            guard let self = self else { return }
            
            if isSuccess,
               let mediaMetadata = mediaMetadata,
               let userSource = AppRepository.shared.currentUser {
                LogUtils.printMessage(tag: SnapRepository.TAG, message: "Upload image success!")
                let snap = Snap(
                    id: UUID().uuidString,
                    from: userSource.email,
                    nameUser: userSource.fullName,
                    description: description,
                    urlImage: mediaMetadata.url,
                    nameImage: mediaMetadata.name,
                    status: .pending
                )
                LogUtils.printMessage(tag: SnapRepository.TAG, message: "Snap -> \(snap.toString())")
                self.insert(userIdTarget: userTarget, snap: snap) { isSnapSuccess in
                    snap.status = isSnapSuccess ? .created : .error
                    completion(isSnapSuccess)
                }
            } else {
                LogUtils.printMessage(tag: SnapRepository.TAG, message: "Upload image error!")
                completion(false)
            }
        }
    }
    
    
    private func insert(
        userIdTarget: String,
        snap: Snap,
        completion: @escaping (Bool) -> Void
    ) {
        LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Start Insert Snap <----")
        database.child("users")
            .child(userIdTarget)
            .child("snaps")
            .child(snap.id)
            .setValue(snap.toDictionary()) { error, _ in
                let isSuccess = error == nil
                if isSuccess {
                    LogUtils.printMessage(tag: SnapRepository.TAG, message: "Insert Snap Success!")
                } else {
                    LogUtils.printMessage(
                        tag: SnapRepository.TAG,
                        message: "Insert Snap Error -> \(String(describing: error?.localizedDescription))"
                    )
                }
                LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Finish Insert Snap <----")
                completion(isSuccess)
            }
    }
    
    func delete(
        userId: String,
        snap: Snap,
        completion: @escaping (Bool) -> Void
    ){
        LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Start delete image <----")
        LogUtils.printMessage(tag: SnapRepository.TAG, message: "Snap Image -> \(snap.nameImage)")
        self.mediaService.deleteImage(userId: userId, name: snap.nameImage) { [weak self] isImageDeleted in
            if isImageDeleted {
                LogUtils.printMessage(tag: SnapRepository.TAG, message: "Image successfully deleted!")
                guard let self = self else { return }
                LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Start remove snap <----")
                self.database.child("users")
                    .child(userId)
                    .child("snaps")
                    .child(snap.id)
                    .removeValue { error, _ in
                        
                        if error == nil {
                            LogUtils.printMessage(tag: SnapRepository.TAG, message: "Remove snap success!")
                            completion(true)
                        } else if let error = error {
                            LogUtils.printMessage(
                                tag: SnapRepository.TAG,
                                message: "Remove snap error -> \(String(describing: error.localizedDescription))"
                            )
                            completion(false)
                        }
                        LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Finish remove snap <----")
                    }
            } else {
                LogUtils.printMessage(tag: SnapRepository.TAG, message: "Error deleting image!")
            }
            LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Finish delete image <----")
        }
    }
    
    func deleteAll(
        userId: String,
        snaps: [Snap],
        completion: @escaping (Bool) -> Void
    ) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        let semaphore = DispatchSemaphore(value: 1)
        
        LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Start remove all snaps <----")
        var countSuccess = 0
        let count = snaps.count
        var countProcess = 0
        queue.async { [weak self] in
            guard let self = self else { return }
            for snap in snaps {
                _ = semaphore.wait(timeout: .now() + 10)
                
                self.delete(userId: userId, snap: snap) { isSnapDeletedSuccess in
                    countProcess+=1
                    if isSnapDeletedSuccess {
                        LogUtils.printMessage(tag: SnapRepository.TAG, message: "deleteAll -> \(snap.id) deleted!")
                        countSuccess+=1
                        LogUtils.printMessage(tag: SnapRepository.TAG, message: "deleteAll -> countSuccess: \(countSuccess), count: \(count)")
                    } else {
                        LogUtils.printMessage(tag: SnapRepository.TAG, message: "deleteAll -> \(snap.id) delete error!")
                    }
                    
                    semaphore.signal()
                    if countProcess == count {
                        LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Finish remove all snaps <----")
                        completion(countSuccess == count)
                    }
                }
            }
        }
    }
    
    func registerObserveSnapsAdded(
        userId: String,
        completion: @escaping (Snap?)-> Void
    ) {
        LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Start Observe Snaps Added <----")
        getSnapReference(userId: userId)
            .observe(.childAdded) { snapshot in
                
                guard
                    let value = snapshot.value as? NSDictionary
                else {
                    LogUtils.printMessage(tag: SnapRepository.TAG, message: "Added snaps error -> Snapshot value is null")
                    completion(nil)
                    return
                }
                
                let snap = Snap.create(id: snapshot.key, dictionary: value, status: .created)
                LogUtils.printMessage(tag: SnapRepository.TAG, message: "Snap Added -> \(snap.toString())")
                completion(snap)
            }
    }
    
    func registerObserveSnapsRemoved(
        userId: String,
        completion: @escaping (Snap?)-> Void
    ) {
        LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Start Observe Snaps Removed <----")
        getSnapReference(userId: userId)
            .observe(.childRemoved) { snapshot in
                
                guard
                    let value = snapshot.value as? NSDictionary
                else {
                    LogUtils.printMessage(tag: SnapRepository.TAG, message: "Remove snaps error -> Snapshot value is null")
                    completion(nil)
                    return
                }
                
                let snap = Snap.create(id: snapshot.key, dictionary: value, status: .deleted)
                LogUtils.printMessage(tag: SnapRepository.TAG, message: "Snap Removed -> \(snap.toString())")
                completion(snap)
            }
    }
    
    private func getSnapReference(userId: String) -> DatabaseReference {
        database.child("users")
            .child(userId)
            .child("snaps")
    }
}
