//
//  StoryDetailViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 22/12/21.
//

import UIKit


class StoryDetailViewController: UIViewController {
    private let maxStorys = 30
    private var storysCount: Int = 0
    public var story:StoryItemViewModel! {
        didSet {
            storysCount  = story.count < maxStorys ? story.count : maxStorys
        }
    }
    public let progressIndicatorViewTag = 88
    public let progressViewTag = 99
    
    
    private var progressView: UIView?
    public var getProgressView: UIView {
        if let progressView = self.progressView {
            return progressView
        }
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        self.progressView = v
        self.view.addSubview(self.getProgressView)
        return v
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pv = getProgressView
        NSLayoutConstraint.activate([
            pv.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            pv.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
            self.view.rightAnchor.constraint(equalTo: pv.rightAnchor),
            pv.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        //-------------------------------------------------------------------------
        print("Progressor count: \(getProgressView.subviews.count)")
        let padding: CGFloat = 8 //GUI-Padding
        let height: CGFloat = 3
        var storyBarViewArray: [StoryBarView] = []
        //var pvArray: [IGSnapProgressView] = []
        
        for index in 0..<storysCount{
            let storyBarView = createStoryBarView(tag: index+progressIndicatorViewTag)
            getProgressView.addSubview(storyBarView)
            storyBarViewArray.append(storyBarView)
            
//            let pv = IGSnapProgressView()
//            pv.translatesAutoresizingMaskIntoConstraints = false
//            pvIndicator.addSubview(applyProperties(pv))
//            pvArray.append(pv)
        }
        
        // Setting Constraints for all progressView indicators
        for index in 0..<storyBarViewArray.count {
            let pvIndicator = storyBarViewArray[index]
            if index == 0 {
                pvIndicator.leftConstraiant = pvIndicator.leftAnchor.constraint(equalTo: self.getProgressView.leftAnchor, constant: padding)
                NSLayoutConstraint.activate([
                    pvIndicator.leftConstraiant!,
                    pvIndicator.centerYAnchor.constraint(equalTo: self.getProgressView.centerYAnchor),
                    pvIndicator.heightAnchor.constraint(equalToConstant: height)
                    ])
                if storyBarViewArray.count == 1 {
                    pvIndicator.rightConstraiant = self.getProgressView.rightAnchor.constraint(equalTo: pvIndicator.rightAnchor, constant: padding)
                    pvIndicator.rightConstraiant!.isActive = true
                }
            }else {
                let prePVIndicator = storyBarViewArray[index-1]
                pvIndicator.widthConstraint = pvIndicator.widthAnchor.constraint(equalTo: prePVIndicator.widthAnchor, multiplier: 1.0)
                pvIndicator.leftConstraiant = pvIndicator.leftAnchor.constraint(equalTo: prePVIndicator.rightAnchor, constant: padding)
                NSLayoutConstraint.activate([
                    pvIndicator.leftConstraiant!,
                    pvIndicator.centerYAnchor.constraint(equalTo: prePVIndicator.centerYAnchor),
                    pvIndicator.heightAnchor.constraint(equalToConstant: height),
                    pvIndicator.widthConstraint!
                    ])
                if index == storyBarViewArray.count-1 {
                    pvIndicator.rightConstraiant = self.view.rightAnchor.constraint(equalTo: pvIndicator.rightAnchor, constant: padding)
                    pvIndicator.rightConstraiant!.isActive = true
                }
            }
        }
        
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
