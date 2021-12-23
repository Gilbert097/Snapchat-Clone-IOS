//
//  StoryDetailViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 22/12/21.
//

import UIKit


class StoryDetailViewController: UIViewController {
    private static let TAG = "StoryDetailViewController"
    
    public var story:StoryItemViewModel! {
        didSet {
            storysCount  = story.count < maxStorys ? story.count : maxStorys
        }
    }
    public let progressIndicatorViewTag = 88
    public let progressViewTag = 99
    private let maxStorys = 30
    private var storysCount: Int = 0
    private var progressView: UIView!
    private var storyIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView = createProgressBarView()
        configLayoutConstraints()
        loadStorysBarView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startStoryProgress(with: storyIndex)
    }
    
    private func loadStorysBarView() {
        LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Progressor count: \(progressView.subviews.count)")
        let padding: CGFloat = 8 //GUI-Padding
        let height: CGFloat = 3
        var storyBarViewArray: [StoryBarView] = []
        var storyBarProgressViewArray: [StoryBarProgressView] = []
        
        for index in 0..<storysCount{
            let storyBarView = createStoryBarView(tag: index+progressIndicatorViewTag)
            progressView.addSubview(storyBarView)
            storyBarViewArray.append(storyBarView)
            
            let storyProgressView = createStoryBarProgressView()
            storyBarView.addSubview(storyProgressView)
            storyBarProgressViewArray.append(storyProgressView)
        }
        
        // Setting Constraints for all storys bar
        for index in 0..<storyBarViewArray.count {
            let storyBarCurrent = storyBarViewArray[index]
            if index == 0 {
                storyBarCurrent.leftConstraiant = storyBarCurrent.leftAnchor.constraint(equalTo: self.progressView.leftAnchor, constant: padding)
                NSLayoutConstraint.activate([
                    storyBarCurrent.leftConstraiant!,
                    storyBarCurrent.centerYAnchor.constraint(equalTo: self.progressView.centerYAnchor),
                    storyBarCurrent.heightAnchor.constraint(equalToConstant: height)
                ])
                if storyBarViewArray.count == 1 {
                    storyBarCurrent.rightConstraiant = self.progressView.rightAnchor.constraint(equalTo: storyBarCurrent.rightAnchor, constant: padding)
                    storyBarCurrent.rightConstraiant!.isActive = true
                }
            }else {
                let storyBarPrevious = storyBarViewArray[index-1]
                storyBarCurrent.widthConstraint = storyBarCurrent.widthAnchor.constraint(equalTo: storyBarPrevious.widthAnchor, multiplier: 1.0)
                storyBarCurrent.leftConstraiant = storyBarCurrent.leftAnchor.constraint(equalTo: storyBarPrevious.rightAnchor, constant: padding)
                NSLayoutConstraint.activate([
                    storyBarCurrent.leftConstraiant!,
                    storyBarCurrent.centerYAnchor.constraint(equalTo: storyBarPrevious.centerYAnchor),
                    storyBarCurrent.heightAnchor.constraint(equalToConstant: height),
                    storyBarCurrent.widthConstraint!
                ])
                let isStoryBarLast = index == (storyBarViewArray.count - 1)
                if  isStoryBarLast {
                    storyBarCurrent.rightConstraiant = self.view.rightAnchor.constraint(equalTo: storyBarCurrent.rightAnchor, constant: padding)
                    storyBarCurrent.rightConstraiant!.isActive = true
                }
            }
        }
        
        // Setting Constraints for all storys bar progress
        for index in 0..<storyBarProgressViewArray.count {
            let storyProgress = storyBarProgressViewArray[index]
            let storybar = storyBarViewArray[index]
            storyProgress.widthConstraint = storyProgress.widthAnchor.constraint(equalToConstant: 0)
            NSLayoutConstraint.activate([
                storyProgress.leftAnchor.constraint(equalTo: storybar.leftAnchor),
                storyProgress.heightAnchor.constraint(equalTo: storybar.heightAnchor),
                storyProgress.topAnchor.constraint(equalTo: storybar.topAnchor),
                storyProgress.widthConstraint!
                //storyProgress.widthAnchor.constraint(equalTo: storybar.widthAnchor)
            ])
        }
    }
    
    private func configLayoutConstraints() {
        NSLayoutConstraint.activate([
            progressView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            progressView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
            self.view.rightAnchor.constraint(equalTo: progressView.rightAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    private func createProgressBarView() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(v)
        return v
    }
    
    private func createStoryBarView(tag: Int? = nil) -> StoryBarView {
        let storyBarView = StoryBarView()
        storyBarView.translatesAutoresizingMaskIntoConstraints = false
        return applyProperties(storyBarView,with: tag, alpha:0.2)
    }
    
    private func createStoryBarProgressView() -> StoryBarProgressView {
        let storyBarProgressView = StoryBarProgressView()
        storyBarProgressView.translatesAutoresizingMaskIntoConstraints = false
        return applyProperties(storyBarProgressView)
    }
    
    private func applyProperties<T: UIView>(_ view: T, with tag: Int? = nil, alpha: CGFloat = 1.0) -> T {
        view.layer.cornerRadius = 1
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white.withAlphaComponent(alpha)
        if let tagValue = tag {
            view.tag = tagValue
        }
        return view
    }
    
    
    private func startStoryProgress(with sIndex: Int) {
        if let indicatorView = getStoryBarView(with: sIndex),
           let pv = getStoryProgressView(with: sIndex) {
            pv.start(with: 5.0, holderView: indicatorView, completion: { [weak self] (identifier, snapIndex, isCancelledAbruptly) in
                guard let self = self else { return }
                if self.storyIndex < self.story.count - 1 {
                    self.storyIndex+=1
                    self.startStoryProgress(with: self.storyIndex)
                }
                LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Finish")
            })
        }
    }
    
    func getStoryBarView(with index: Int) -> StoryBarView? {
        let storyBar =  progressView.subviews.filter({
            v in v.tag == index+progressIndicatorViewTag
        }).first as? StoryBarView ?? nil
        
        return storyBar
    }
    
    func getStoryProgressView(with index: Int) -> StoryBarProgressView? {
        if progressView.subviews.count > 0 {
            let pv = getStoryBarView(with: index)?.subviews.first as? StoryBarProgressView
            guard
                let pv = pv,
                let currentStory = self.story else {
                    fatalError("story not found")
                }
            pv.story = currentStory
            pv.story_identifier = currentStory.storys[index].id
            pv.snapIndex = index
            return pv
        }
        return nil
    }
    
    
}

final class StoryBarView: UIView {
    public var widthConstraint: NSLayoutConstraint?
    public var leftConstraiant: NSLayoutConstraint?
    public var rightConstraiant: NSLayoutConstraint?
}


final class StoryBarProgressView: UIView, ViewAnimator {
    public var story_identifier: String?
    public var snapIndex: Int?
    public var story: StoryItemViewModel!
    public var widthConstraint: NSLayoutConstraint?
    public var state: ProgressorState = .notStarted
}
