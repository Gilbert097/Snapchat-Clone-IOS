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
        urlImage: Event<String>,
        isNextButtonVisible: Event<Bool>,
        isPreviousButtonVisible: Event<Bool>,
        isCounterTextVisible: Event<Bool>
    )
    
    typealias Input = Event<Bool>
    
    func bind(input: Input) -> Output
    
    func loadSnapDetail()
    
    func nextSnap()
    
    func previousSnap()
}
