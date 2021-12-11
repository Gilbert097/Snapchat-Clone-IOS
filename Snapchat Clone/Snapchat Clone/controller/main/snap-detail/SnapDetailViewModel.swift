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
    private var index = 0
    
    init(snapItemViewModel: SnapItemViewModel){
        self.snapItemViewModel = snapItemViewModel
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
        
    }
    
}
