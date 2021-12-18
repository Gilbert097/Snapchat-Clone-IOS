//
//  CreateStoryViewModelProocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 18/12/21.
//

import Foundation

protocol CreateStoryViewModelProtocol {
    
    typealias Output = Event<EventData<CreateStoryEventType>>
    typealias Input = Event<Data?>
    
    func bind(input: Input) -> Output
    
    func sendStory()
}
