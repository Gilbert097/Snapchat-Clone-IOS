//
//  SnapDetailViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 12/10/21.
//

import Foundation

public class SnapListViewModel: SnapListViewModelProtocol {
    private static let TAG = "SnapListViewModel"
    
    private let output = Event<EventData<SnapListEventType>>(.init(type: .none))
    private let authenticationService: UserAuthenticationServiceProtocol
    private let snapRepository: SnapRepositoryProtocol
    var snaps: [SnapItemViewModel] {
        get {
            snapMap.map { $0.value }
        }
    }
    private var snapMap: [String: SnapItemViewModel] = [:]
    
    init(
        authenticationService: UserAuthenticationServiceProtocol,
        snapRepository: SnapRepositoryProtocol
    ) {
        self.authenticationService = authenticationService
        self.snapRepository = snapRepository
    }
    
    func bind() -> Output {
        return output
    }
    
    func start(){
        registerObserveSnapsAdded()
        registerObserveSnapsRemoved()
    }
    
    func signOut() {
        authenticationService.signOut()
        output.value = .init(type: .navigationToBack)
    }
    
    func deleteItem(item: SnapItemViewModel) {
        if let currentUser = AppRepository.shared.currentUser {
            snapRepository.deleteAll(userId: currentUser.id, snaps: item.snaps) { isSuccess in
                if isSuccess {
                    LogUtils.printMessage(tag: SnapListViewModel.TAG, message: "Remove all snap success!")
                } else {
                    LogUtils.printMessage(tag: SnapListViewModel.TAG, message: "Remove all snap error!")
                }
            }
        }
    }
    
    private func registerObserveSnapsRemoved() {
        if let currentUser = AppRepository.shared.currentUser {
            snapRepository.registerObserveSnapsRemoved(userId: currentUser.id) { [weak self] snap in
                if let snap = snap{
                    LogUtils.printMessage(
                        tag: SnapListViewModel.TAG,
                        message: "Snap removed received -> id: \(snap.id), description: \(snap.description)"
                    )
                    if let self = self,
                       let snapItemViewModel = self.snapMap[snap.nameUser] {
                        LogUtils.printMessage(tag: SnapListViewModel.TAG, message: "\(snap.nameUser) user snaps found!")
                        var index = 0
                        for snapItem in snapItemViewModel.snaps {
                            if snapItem.id == snap.id {
                                snapItemViewModel.snaps.remove(at: index)
                                LogUtils.printMessage(tag: SnapListViewModel.TAG, message: "Snap \(snap.id) removed from item list!")
                                if snapItemViewModel.count == 0 {
                                    LogUtils.printMessage(tag: SnapListViewModel.TAG, message: "\(snap.nameUser) user removed from list!")
                                    self.snapMap.removeValue(forKey: snap.nameUser)
                                }
                                self.output.value = .init(type: .reloadSnapList)
                                return
                            }
                            index+=1
                        }
                    }
                } else {
                    LogUtils.printMessage(tag: SnapListViewModel.TAG, message: "Error getting snap removed")
                }
            }
        }
    }
    
    private func registerObserveSnapsAdded(){
        if let currentUser = AppRepository.shared.currentUser {
            self.snapRepository.registerObserveSnapsAdded(userId: currentUser.id) { [weak self] snap in
                if let self = self,
                   let snap = snap {
                    LogUtils.printMessage(tag: SnapListViewModel.TAG, message: "Snap Added received -> \(String(describing: snap.id))")
                    
                    if let snapItemViewModel = self.snapMap[snap.nameUser] {
                        snapItemViewModel.addSnap(snap: snap)
                    } else {
                        self.snapMap[snap.nameUser] = .init(userName: snap.nameUser, snap: snap)
                    }
                    
                    self.output.value = .init(type: .reloadSnapList)
                }
            }
        }
    }
    
}
