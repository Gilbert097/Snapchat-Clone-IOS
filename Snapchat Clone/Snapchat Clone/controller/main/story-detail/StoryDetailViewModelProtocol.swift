//
//  StoryDetailViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 24/12/21.
//

import Foundation

protocol StoryDetailViewModelProtocol{
    typealias Output = Event<EventData<StoryDetailEventType>>
    
    func bind() -> Output
    
    var storysCount: Int { get }
    var storyBars: [StoryBarViewModel] { get }
    
    func nextStory()
    func previousStory()
    func start()
    
}
