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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView = createProgressBarView()
        configLayoutConstraints()
        loadStorysBarView()
    }
    
    private func loadStorysBarView() {
        LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Progressor count: \(progressView.subviews.count)")
        let padding: CGFloat = 8 //GUI-Padding
        let height: CGFloat = 3
        var storyBarViewArray: [StoryBarView] = []
        //var pvArray: [IGSnapProgressView] = []
        
        for index in 0..<storysCount{
            let storyBarView = createStoryBarView(tag: index+progressIndicatorViewTag)
            progressView.addSubview(storyBarView)
            storyBarViewArray.append(storyBarView)
            
            //            let pv = IGSnapProgressView()
            //            pv.translatesAutoresizingMaskIntoConstraints = false
            //            pvIndicator.addSubview(applyProperties(pv))
            //            pvArray.append(pv)
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
        storyBarView.layer.cornerRadius = 1
        storyBarView.layer.masksToBounds = true
        //storyBarView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        storyBarView.backgroundColor = UIColor.red
        if let tagValue = tag {
            storyBarView.tag = tagValue
        }
        return storyBarView
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
}

final class StoryBarView: UIView {
    public var widthConstraint: NSLayoutConstraint?
    public var leftConstraiant: NSLayoutConstraint?
    public var rightConstraiant: NSLayoutConstraint?
}
