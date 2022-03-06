//
//  StoryDetailViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 22/12/21.
//

import UIKit
import SDWebImage

class StoryDetailViewController: UIViewController {
    private static let TAG = "StoryDetailViewController"
    private static let STORY = "Story"
    
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var closeButton: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var tapLeftView: UIView!
    @IBOutlet weak var tapRightView: UIView!
    
    public var viewModel: StoryDetailViewModelProtocol!
    public let storyBarViewTag = 88
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createStoryBarsView()
        configureBind()
        configureTapView(view: closeButton)
        configureTapView(view: tapLeftView)
        configureTapView(view: tapRightView)
    }
    
    private func configureTapView(view: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapView(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func onTapView(tapGestureRecognizer: UITapGestureRecognizer) {
        if let view = tapGestureRecognizer.view {
            switch view {
            case tapLeftView:
                LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Left tap!")
                self.viewModel.previousStory()
                break;
            case tapRightView:
                LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Right tap!")
                self.viewModel.nextStory()
                break;
            case closeButton:
                LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Close image tap!")
                dismiss(animated: true)
                break
            default:
                LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "tap action not implemented!")
            }
        } else {
            LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "View tap gesture is nil!")
        }
    }
    
    private func configureBind() {
        let output = viewModel.bind()
        
        output.nextStory.bind { [weak self] storyBarViewModel in
            guard
                let self = self,
                let storyBar = storyBarViewModel
            else { return }
            
            self.startStory(storyBar: storyBar)
        }
        
        output.resetStory.bind { [weak self] storyBarViewModel in
            guard
                let self = self,
                let storyBar = storyBarViewModel,
                let storyProgress = self.getStoryProgressView(index: storyBar.index)
            else { return }
            
            LogUtils.printMessage(tag: StoryDetailViewController.STORY, message: "Reset Story Index \(storyBar.index) - > resetStory")
            storyProgress.reset()
        }
        
        output.finishStory.bind { [weak self] storyBarViewModel in
            guard
                let self = self,
                let storyBar = storyBarViewModel,
                let storyProgress = self.getStoryProgressView(index: storyBar.index)
            else { return }
            
            LogUtils.printMessage(tag: StoryDetailViewController.STORY, message: "Execute finish progress")
            storyProgress.finish()
        }
        
        output.event.bind { eventData in
            switch eventData.type {
            case .none:
                break
            case .showMessageError:
                break
            case .showMessageSuccess:
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.start()
    }
    
    private func createStoryBarsView() {
        LogUtils.printMessage(tag: StoryDetailViewController.STORY, message: "Story bar count: \(progressBarView.subviews.count)")
        let padding: CGFloat = 8 //GUI-Padding
        let height: CGFloat = 3
        var storyBarViewArray: [StoryBarView] = []
        var storyBarProgressViewArray: [StoryBarProgressView] = []
        
        for index in 0..<viewModel.storysCount{
            let storyBarView = createStoryBarView(tag: index+storyBarViewTag)
            progressBarView.addSubview(storyBarView)
            storyBarViewArray.append(storyBarView)
            
            let storyProgressView = createStoryBarProgressView(index: index)
            storyBarView.addSubview(storyProgressView)
            storyBarProgressViewArray.append(storyProgressView)
        }
        
        // Setting Constraints for all storys bar
        for index in 0..<storyBarViewArray.count {
            let storyBarCurrent = storyBarViewArray[index]
            if index == 0 {
                storyBarCurrent.leftConstraiant = storyBarCurrent.leftAnchor.constraint(equalTo: self.progressBarView.leftAnchor, constant: padding)
                NSLayoutConstraint.activate([
                    storyBarCurrent.leftConstraiant!,
                    storyBarCurrent.centerYAnchor.constraint(equalTo: self.progressBarView.centerYAnchor),
                    storyBarCurrent.heightAnchor.constraint(equalToConstant: height)
                ])
                if storyBarViewArray.count == 1 {
                    storyBarCurrent.rightConstraiant = self.progressBarView.rightAnchor.constraint(equalTo: storyBarCurrent.rightAnchor, constant: padding)
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
            ])
        }
    }
    
    private func createStoryBarView(tag: Int? = nil) -> StoryBarView {
        let storyBarView = StoryBarView()
        storyBarView.translatesAutoresizingMaskIntoConstraints = false
        return applyProperties(storyBarView,with: tag, alpha:0.2)
    }
    
    private func createStoryBarProgressView(index: Int) -> StoryBarProgressView {
        let storyBarProgressView = StoryBarProgressView()
        storyBarProgressView.viewModel = viewModel.storyBars[index]
        storyBarProgressView.translatesAutoresizingMaskIntoConstraints = false
        return applyProperties(storyBarProgressView)
    }
    
    private func applyProperties<T: UIView>(
        _ view: T,
        with tag: Int? = nil,
        alpha: CGFloat = 1.0
    ) -> T {
        view.layer.cornerRadius = 1
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white.withAlphaComponent(alpha)
        if let tagValue = tag {
            view.tag = tagValue
        }
        return view
    }
    
    private func startStory(storyBar: StoryBarViewModel) {
        if let storyBarView = getStoryBarView(with: storyBar.index),
           let storyProgress = getStoryProgressView(index: storyBar.index, storyBar: storyBarView) {
        
            if !storyBar.isCompletelyVisible {
                downloadStoryImage(
                    storyBar: storyBar,
                    storyProgress: storyProgress,
                    storyBarView: storyBarView
                )
            } else {
                startStoryProgress(storyProgress: storyProgress, storyBarView: storyBarView)
            }
        }
    }
    
    private func downloadStoryImage(
        storyBar: StoryBarViewModel,
        storyProgress: StoryBarProgressView,
        storyBarView: StoryBarView
    ) {
        LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "-----> Start download image <-----")
        LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Name image -> \(storyBar.story.nameImage)")
        storyImageView.sd_setImage(with: URL(string: storyBar.story.urlImage)) { [weak self] image, error, cacheType, url in
            if error == nil {
                storyBar.isCompletelyVisible = true
                LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Download image success!")
                self?.startStoryProgress(storyProgress: storyProgress, storyBarView: storyBarView)
            } else if let error = error {
                storyBar.isCompletelyVisible = false
                LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Download image erro -> \(error.localizedDescription)")
            }
            LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "-----> Finish download image <-----")
        }
    }
    
    private func startStoryProgress(
        storyProgress: StoryBarProgressView,
        storyBarView: StoryBarView
    ) {
        LogUtils.printMessage(tag: StoryDetailViewController.STORY, message: "-----> Start animate story <-----")
        LogUtils.printMessage(tag: StoryDetailViewController.STORY, message: "Story index -> \(storyProgress.viewModel.index)")
        storyProgress.start(with: 5.0, holderView: storyBarView, completion: { [weak self] (identifier, snapIndex, isCancelledAbruptly) in
            LogUtils.printMessage(tag: StoryDetailViewController.STORY, message: "-----> Finish animate story <-----")
            guard let self = self else { return }
            if !isCancelledAbruptly {
                LogUtils.printMessage(tag: StoryDetailViewController.STORY, message: "isCancelledAbruptly is False")
                self.viewModel.nextStory()
            } else {
                LogUtils.printMessage(tag: StoryDetailViewController.STORY, message: "isCancelledAbruptly is true")
            }
        })
    }
    
    private func getStoryProgressView(index: Int) -> StoryBarProgressView? {
        if let storyBarView = self.getStoryBarView(with: index){
            return self.getStoryProgressView(index: index, storyBar: storyBarView)
        }
        return nil
    }
    
    private func getStoryBarView(with index: Int) -> StoryBarView? {
        let storyBar =  progressBarView.subviews.filter({
            v in v.tag == index+storyBarViewTag
        }).first as? StoryBarView ?? nil
        
        return storyBar
    }
    
    private func getStoryProgressView(index: Int, storyBar: StoryBarView) -> StoryBarProgressView? {
        if progressBarView.subviews.count > 0 {
            let storyProgress = storyBar.subviews.first as? StoryBarProgressView
            return storyProgress
        }
        return nil
    }
}
