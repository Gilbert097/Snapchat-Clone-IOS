//
//  SnapDetailViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 09/12/21.
//

import Foundation

protocol SnapDetailViewModelProtocol {
    
    typealias Output = (
        description: Event<String>,
        counterText: Event<String>,
        isNextButtonVisible: Event<Bool>,
        isPreviousButtonVisible: Event<Bool>,
        isCounterTextVisible: Event<Bool>
    )
    
    //typealias Output = Event<EventData<CreateAccountEventType>>
    
    func bind() -> Output
    
    func loadSnapDetail()
    
    func nextSnap()
    
    func previousSnap()
}
