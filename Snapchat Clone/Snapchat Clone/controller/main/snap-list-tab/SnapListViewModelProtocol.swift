//
//  SnapDetailViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 12/10/21.
//

import Foundation
protocol SnapListViewModelProtocol {
    
    typealias Output = Event<EventData<SnapListEventType>>
    
    func bind() -> Output
    
    func signOut()
    
    func loadSnaps()
    
    var snaps: [SnapItemViewModel] { get }
}
