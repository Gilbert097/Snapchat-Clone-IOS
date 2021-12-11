//
//  SnapDetailViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 09/12/21.
//

import Foundation

class SnapDetailViewModel: SnapDetailViewModelProtocol {
    private let output: Output =  (
        description: Event<String>(""),
        counterText: Event<String>("")
    )
    
    private let snapItemViewModel: SnapItemViewModel
    private var index = 0
    
    init(snapItemViewModel: SnapItemViewModel){
        self.snapItemViewModel = snapItemViewModel
    }
    
    func bind() -> Output {
        output
    }
    
    func loadSnapDetail(){
        showSnap()
    }
    
    func nextSnap(){
        if index < (snapItemViewModel.count - 1) {
            index+=1
            showSnap()
        }
    }
    
    func previousSnap(){
        if (index - 1) > -1 {
            index-=1
            showSnap()
        }
    }
    
    private func showSnap(){
        let snap = snapItemViewModel.snaps[index]
        output.description.value = snap.description
        output.counterText.value = "\(index + 1) / \(snapItemViewModel.count)"
    }
    
}
