//
//  StoryBarViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 24/12/21.
//

import Foundation

class StoryBarViewModel {
    var index: Int
    var story: Story
    var lastPlayedSnapIndex = 0
    var isCompletelyVisible = false
    var isCancelledAbruptly = false
    
    init(index: Int, story: Story) {
        self.index = index
        self.story = story
    }
}
