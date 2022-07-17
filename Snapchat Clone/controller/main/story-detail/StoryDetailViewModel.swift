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
   
    private let output: Output =  (
        event:Event<EventData<StoryDetailEventType>>(.init(type: .none, info: nil)),
        nextStory: Event<StoryBarViewModel?>(nil),
        resetStory: Event<StoryBarViewModel?>(nil),
        finishStory: Event<StoryBarViewModel?>(nil),
        userName: Event<String>("")
    )
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
        output.userName.value = storyItemViewModel.userName
        return output
    }
    
    func start() {
        showStory()
    }
    
    func previousStory() {
        if storyIndex > 0 {
            abortExecution(event: output.resetStory)
            storyIndex-=1
            showStory()
        }
    }
    
    func nextStory() {
        if storyIndex < storysCount - 1 {
            abortExecution(event: output.finishStory)
            storyIndex+=1
            showStory()
        } else if storyIndex == storysCount - 1 {
            output.event.value = .init(type: .closeScreen, info: nil)
        }
    }
    
    func abortExecution(event: Event<StoryBarViewModel?>){
        let currentStory = storyBars[storyIndex]
        if currentStory.state == .running {
            LogUtils.printMessage(tag: StoryDetailViewModel.TAG, message: "Story Index: \(storyIndex) is running")
            event.value = currentStory
        }
    }
    
    private func showStory() {
        let nextStory = self.storyBars[storyIndex]
        self.output.nextStory.value = nextStory
    }
}

