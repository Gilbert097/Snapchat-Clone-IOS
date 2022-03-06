//
//  StoryDetailViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 24/12/21.
//

import Foundation

protocol StoryDetailViewModelProtocol{
    
//    typealias Output = (
//        description: Event<String>,
//        counterText: Event<String>,
//        urlImage: Event<String>,
//        isNextButtonVisible: Event<Bool>,
//        isPreviousButtonVisible: Event<Bool>,
//        isCounterTextVisible: Event<Bool>
//    )
    
    typealias Output = (
        event:Event<EventData<StoryDetailEventType>>,
        nextStory: Event<StoryBarViewModel?>,
        resetStory: Event<StoryBarViewModel?>,
        finishStory: Event<StoryBarViewModel?>
    )
    
    func bind() -> Output
    
    var storysCount: Int { get }
    var storyBars: [StoryBarViewModel] { get }
    
    func nextStory()
    func previousStory()
    func start()
    
}
