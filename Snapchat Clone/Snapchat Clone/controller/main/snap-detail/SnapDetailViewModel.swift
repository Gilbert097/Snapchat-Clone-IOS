//
//  SnapDetailViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 09/12/21.
//

import Foundation

class SnapDetailViewModel: SnapDetailViewModelProtocol {
    
    private static let TAG = "SnapDetailViewModel"
    
    private let output: Output =  (
        description: Event<String>(""),
        counterText: Event<String>(""),
        urlImage: Event<String>(""),
        isNextButtonVisible: Event<Bool>(true),
        isPreviousButtonVisible: Event<Bool>(false),
        isCounterTextVisible: Event<Bool>(true)
    )
    
    private let snapItemViewModel: SnapItemViewModel
    private let snapRepository: SnapRepositoryProtocol
    private var index = 0
    
    init(
        snapItemViewModel: SnapItemViewModel,
        snapRepository: SnapRepositoryProtocol
    ){
        self.snapItemViewModel = snapItemViewModel
        self.snapRepository = snapRepository
    }
    
    func bind(input: Input) -> Output {
        input.bind {[weak self] isDownloadImageSuccess in
            if isDownloadImageSuccess {
                LogUtils.printMessage(tag: SnapDetailViewModel.TAG, message: "Download image success!")
                self?.deleteCurrentSnap()
            } else {
                LogUtils.printMessage(tag: SnapDetailViewModel.TAG, message: "Download image error!")
            }
        }
        return output
    }
    
    func loadSnapDetail(){
        if snapItemViewModel.count == 1 {
            output.isNextButtonVisible.value = false
            output.isPreviousButtonVisible.value = false
            output.isCounterTextVisible.value = false
        }
        showSnap()
    }
    
    func nextSnap(){
        let maxIndex = (snapItemViewModel.count - 1)
        if index <  maxIndex{
            index+=1
            showSnap()
        }
        
        output.isNextButtonVisible.value = !(index == maxIndex)
        output.isPreviousButtonVisible.value = index > 0
    }
    
    func previousSnap(){
        let maxIndex = (snapItemViewModel.count - 1)
        
        if (index - 1) > -1 {
            index-=1
            showSnap()
        }
        
        output.isNextButtonVisible.value = index < maxIndex
        output.isPreviousButtonVisible.value = !(index == 0)
    }
    
    private func showSnap(){
        let snap = snapItemViewModel.snaps[index]
        output.urlImage.value = snap.urlImage
        output.description.value = snap.description
        output.counterText.value = "\(index + 1) / \(snapItemViewModel.count)"
    }
    
    private func deleteCurrentSnap() {
        if let user = AppRepository.shared.currentUser {
            let snap = snapItemViewModel.snaps[index]
            let isDelete = snap.status != .pending && snap.status != .deleted
            if isDelete {
                LogUtils.printMessage(tag: SnapDetailViewModel.TAG, message: "----> Start delete snap <----")
                LogUtils.printMessage(tag: SnapDetailViewModel.TAG, message: "Current snap -> Id: \(snap.id), Description: \(snap.description)")
                snap.status = .pending
                snapRepository.delete(userId: user.id, snap: snap) { isSnapDeleted in
                    if isSnapDeleted {
                        snap.status = .deleted
                        LogUtils.printMessage(tag: SnapDetailViewModel.TAG, message: "Delete snap success!")
                        
                    } else {
                        snap.status = .error
                        LogUtils.printMessage(tag: SnapDetailViewModel.TAG, message: "Delete snap error!")
                    }
                    LogUtils.printMessage(tag: SnapDetailViewModel.TAG, message: "----> Finish delete snap <----")
                }
            } else {
                LogUtils.printMessage(tag: SnapDetailViewModel.TAG, message: "Snap has already been deleted!")
                LogUtils.printMessage(tag: SnapDetailViewModel.TAG, message: "Current snap -> Id: \(snap.id), Description: \(snap.description)")
            }
        }
    }
    
}
