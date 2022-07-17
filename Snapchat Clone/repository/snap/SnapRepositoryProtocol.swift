//
//  SnapRepositoryProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 02/12/21.
//

import Foundation

protocol SnapRepositoryProtocol {
    
    func createSnap(
        userTarget: String,
        description: String,
        imageData: Data,
        completion: @escaping (Bool) -> Void
    )
    
    func registerObserveSnapsAdded(
        userId: String,
        completion: @escaping (Snap?)-> Void
    )
    
    func delete(
        userId: String,
        snap: Snap,
        completion: @escaping (Bool) -> Void
    )
    
    func deleteAll(
        userId: String,
        snaps: [Snap],
        completion: @escaping (Bool) -> Void
    )
    
    func registerObserveSnapsRemoved(
        userId: String,
        completion: @escaping (Snap?)-> Void
    )
}
