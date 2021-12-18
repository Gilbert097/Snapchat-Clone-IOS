//
//  CreateStoryViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 18/12/21.
//

import Foundation

class CreateStoryViewModel: CreateStoryViewModelProtocol {
    
    private let output = Event<EventData<CreateStoryEventType>>(.init(type: .none))
    
    func bind(input: Input) -> Output {
        output
    }
    
    
}
