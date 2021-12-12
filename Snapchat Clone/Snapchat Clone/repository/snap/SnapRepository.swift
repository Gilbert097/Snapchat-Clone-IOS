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
    
    init() {
        database = Database.database().reference()
    }
    
    func insert(
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
        LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Start remove snap <----")
        database.child("users")
            .child(userId)
            .child("snaps")
            .child(snap.id)
            .removeValue { error, _ in
                if let error = error {
                    LogUtils.printMessage(
                        tag: SnapRepository.TAG,
                        message: "Remove snap error -> \(String(describing: error.localizedDescription))"
                    )
                    completion(false)
                } else {
                    LogUtils.printMessage(tag: SnapRepository.TAG, message: "Remove snap success!")
                    completion(true)
                }
                
                LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Finish remove snap <----")
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
                        LogUtils.printMessage(tag: SnapRepository.TAG, message: "deleteAll -> \(snap.id) deleted error!")
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
