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
            .child(snap.id).setValue(snap.toDictionary()) { error, _ in
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
    
    func registerObserveSnapsByUserId(userId: String, completion: @escaping (Snap?)-> Void) {
        LogUtils.printMessage(tag: SnapRepository.TAG, message: "----> Start Get Snaps <----")
        database.child("users")
            .child(userId)
            .child("snaps").observe(.childAdded) { snapshot in
                
                guard
                    let value = snapshot.value as? NSDictionary
                else {
                    LogUtils.printMessage(tag: SnapRepository.TAG, message: "Get snaps error -> Snapshot value is null")
                    completion(nil)
                    return
                }
                
                let snap = Snap.create(id: snapshot.key, dictionary: value)
                LogUtils.printMessage(tag: SnapRepository.TAG, message: "Snap -> \(snap.toString())")
                completion(snap)
            }
    }
}
