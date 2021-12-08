//
//  SnapItemViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 08/12/21.
//

import Foundation

class SnapItemViewModel{
    
    var userName: String
    var snaps: [Snap] = []
    var count: Int  {
        get {
            snaps.count
        }
    }
    var isVisible: Bool  {
        get {
            !(count > 0)
        }
    }
    
    init(userName: String, snap: Snap){
        self.userName = userName
        addSnap(snap: snap)
    }
    
    func addSnap(snap: Snap){
        snaps.append(snap)
    }
}
