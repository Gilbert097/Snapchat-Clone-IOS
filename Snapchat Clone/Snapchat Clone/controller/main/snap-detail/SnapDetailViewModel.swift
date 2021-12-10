//
//  SnapDetailViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 09/12/21.
//

import Foundation

class SnapDetailViewModel: SnapDetailViewModelProtocol {
    
    let snapItemViewModel: SnapItemViewModel
    
    init(snapItemViewModel: SnapItemViewModel){
        self.snapItemViewModel = snapItemViewModel
    }
}
