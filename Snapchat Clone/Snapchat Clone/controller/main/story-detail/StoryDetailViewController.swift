//
//  StoryDetailViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 22/12/21.
//

import UIKit

class StoryDetailViewController: UIViewController {
    private static let TAG = "StoryDetailViewController"
    
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var closeButton: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var storyImageView: UIImageView!
    
    public var viewModel: StoryDetailViewModelProtocol!
    public let progressIndicatorViewTag = 88
    public let progressViewTag = 99
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createStoryBarsView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCloseButtonClick(tapGestureRecognizer:)))
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startStoryProgress()
    }
    
    @objc func onCloseButtonClick(tapGestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    private func createStoryBarsView() {
        LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Progressor count: \(progressBarView.subviews.count)")
        let padding: CGFloat = 8 //GUI-Padding
        let height: CGFloat = 3
        var storyBarViewArray: [StoryBarView] = []
        var storyBarProgressViewArray: [StoryBarProgressView] = []
        
        for index in 0..<viewModel.storysCount{
            let storyBarView = createStoryBarView(tag: index+progressIndicatorViewTag)
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
    
    private func startStoryProgress() {
        if let storyBar = getStoryBarView(with: viewModel.storyIndex),
           let storyProgress = getStoryProgressView(index: viewModel.storyIndex, storyBar: storyBar) {
            storyProgress.start(with: 5.0, holderView: storyBar, completion: { [weak self] (identifier, snapIndex, isCancelledAbruptly) in
                guard let self = self else { return }
                if self.viewModel.storyIndex < self.viewModel.storysCount - 1 {
                    self.viewModel.storyIndex+=1
                    self.startStoryProgress()
                }
                LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Finish")
            })
        }
    }
    
    func getStoryBarView(with index: Int) -> StoryBarView? {
        let storyBar =  progressBarView.subviews.filter({
            v in v.tag == index+progressIndicatorViewTag
        }).first as? StoryBarView ?? nil
        
        return storyBar
    }
    
    func getStoryProgressView(index: Int, storyBar: StoryBarView) -> StoryBarProgressView? {
        if progressBarView.subviews.count > 0 {
            let storyProgress = storyBar.subviews.first as? StoryBarProgressView
            return storyProgress
        }
        return nil
    }
}
