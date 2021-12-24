//
//  StoryDetailViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 24/12/21.
//

import Foundation

protocol StoryDetailViewModelProtocol{
    
    typealias Output = Event<StoryDetailEventType>
   // typealias Input = Event<Data?>
    
    func bind() -> Output
    
    var storysCount: Int { get }
    var storyBars: [StoryBarViewModel] { get }
    var storyIndex: Int { get set }
    
}
