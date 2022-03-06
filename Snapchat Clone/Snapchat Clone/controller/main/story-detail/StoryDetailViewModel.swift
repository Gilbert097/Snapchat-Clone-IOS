//
//  StoryDetailViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 24/12/21.
//

import Foundation

class StoryDetailViewModel: StoryDetailViewModelProtocol {
    private static let TAG = "StoryDetailViewModel"
    
    public var storyBars: [StoryBarViewModel] = []
    public var storysCount: Int = 0
    public var storyIndex = 0
    private let maxStorys = 30
    private let output: Output = .init(.init(type: .none, info: nil))
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
    
    func start() {
        showStory()
    }
    
    func previousStory() {
        if storyIndex >= 0 {
            abortExecution(event: .resetStory)
            storyIndex-=1
            showStory(event: .previousStory)
        }
    }
    
    func nextStory() {
        if storyIndex < storysCount - 1 {
            abortExecution(event: .finishStory)
            storyIndex+=1
            showStory()
        }
    }
    
    func abortExecution(event: StoryDetailEventType){
        let currentStory = storyBars[storyIndex]
        if currentStory.state == .running {
            LogUtils.printMessage(tag: StoryDetailViewModel.TAG, message: "Story Index: \(storyIndex) is running")
            self.output.value = .init(type: event, info: currentStory)
        }
    }
    
    private func showStory(event: StoryDetailEventType = .nextStory) {
        let nextStory = self.storyBars[storyIndex]
        self.output.value = .init(type: event, info: nextStory)
    }
}
