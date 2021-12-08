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
    var snaps: [Snap] = []
    
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
    
    func signOut() {
        authenticationService.signOut()
        output.value = .init(type: .navigationToBack)
    }
    
    func loadSnaps(){
        if let currentUser = AppRepository.shared.currentUser {
            self.snapRepository.registerObserveSnapsByUserId(userId: currentUser.id) { [weak self] snap in
                if let self = self,
                    let snap = snap {
                    LogUtils.printMessage(tag: SnapListViewModel.TAG, message: "Snap received -> \(String(describing: snap.id))")
                    self.snaps.append(snap)
                    self.output.value = .init(type: .reloadSnapList)
                }
            }
        }
    }

}
