//
//  StoryItemViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 18/12/21.
//

import Foundation


class StoryItemViewModel{
    
    var userName: String
    var storys: [Story] = []
    var count: Int  {
        get {
            storys.count
        }
    }
    var isVisible: Bool  {
        get {
            !(count > 0)
        }
    }
    
    init(userName: String, story: Story){
        self.userName = userName
        addStory(story: story)
    }
    
    init(userName: String, storys: [Story]){
        self.userName = userName
        self.storys = storys
    }
    
    func addStory(story: Story){
        storys.append(story)
    }
    
    func copy(
        userName: String? = nil,
        storys: [Story]? = nil
    )-> StoryItemViewModel {
        .init(
            userName: userName ?? self.userName,
            storys: storys ?? self.storys.map({ $0.copy()})
        )
    }
    
}
