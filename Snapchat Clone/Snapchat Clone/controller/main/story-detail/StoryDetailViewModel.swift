//
//  StoryDetailViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 24/12/21.
//

import Foundation

class StoryDetailViewModel: StoryDetailViewModelProtocol {
    
    public var storyBars: [StoryBarViewModel] = []
    public var storysCount: Int = 0
    public var storyIndex = 0
    private let maxStorys = 30
    private let output: Output = .init(.none)
    private var storyItemViewModel: StoryItemViewModel
    
    init(storyItemViewModel: StoryItemViewModel){
        self.storyItemViewModel = storyItemViewModel
        self.storysCount  = storyItemViewModel.count < maxStorys ? storyItemViewModel.count : maxStorys
        for index in 0..<storysCount {
            let story = storyItemViewModel.storys[index]
            self.storyBars.append(.init(index: index, story: story))
        }
    }
    
    func bind() -> Output {
        return output
    }
}
