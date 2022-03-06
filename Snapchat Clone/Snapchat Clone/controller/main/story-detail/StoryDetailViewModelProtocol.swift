//
//  StoryDetailViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 24/12/21.
//

import Foundation

protocol StoryDetailViewModelProtocol{
  
    typealias Output = (
        event:Event<EventData<StoryDetailEventType>>,
        nextStory: Event<StoryBarViewModel?>,
        resetStory: Event<StoryBarViewModel?>,
        finishStory: Event<StoryBarViewModel?>,
        userName: Event<String>
    )
    
    func bind() -> Output
    
    var storysCount: Int { get }
    var storyBars: [StoryBarViewModel] { get }
    
    func nextStory()
    func previousStory()
    func start()
    
}
