//
//  StoryDetailViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 22/12/21.
//

import UIKit

class StoryDetailViewController: UIViewController {
    private static let TAG = "StoryDetailViewController"
    
    public var viewModel: StoryDetailViewModelProtocol!
    public let progressIndicatorViewTag = 88
    public let progressViewTag = 99
    private var progressView: UIView!
    
    internal let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "padrao")
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let detailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Gilberto Silva"
        return label
    }()
    
    internal let lastUpdatedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "6h"
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setImage(#imageLiteral(resourceName: "ic_close"), for: .normal)
        button.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView = createProgressBarView()
        loadUIElements()
        configLayoutConstraints()
        createStoryBarsView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startStoryProgress()
    }
    
    @objc func didTapClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func createStoryBarsView() {
        LogUtils.printMessage(tag: StoryDetailViewController.TAG, message: "Progressor count: \(progressView.subviews.count)")
        let padding: CGFloat = 8 //GUI-Padding
        let height: CGFloat = 3
        var storyBarViewArray: [StoryBarView] = []
        var storyBarProgressViewArray: [StoryBarProgressView] = []
        
        for index in 0..<viewModel.storysCount{
            let storyBarView = createStoryBarView(tag: index+progressIndicatorViewTag)
            progressView.addSubview(storyBarView)
            storyBarViewArray.append(storyBarView)
            
            let storyProgressView = createStoryBarProgressView(index: index)
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
    
    private func loadUIElements(){
        //self.view.backgroundColor = .clear
        self.view.addSubview(progressView)
        self.view.addSubview(userImageView)
        self.view.addSubview(detailView)
        detailView.addSubview(nameLabel)
        detailView.addSubview(lastUpdatedLabel)
//        self.view.addSubview(closeButton)
    }
    
    private func configLayoutConstraints() {
        //Setting constraints for progressView
        NSLayoutConstraint.activate([
            progressView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            progressView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
            self.view.rightAnchor.constraint(equalTo: progressView.rightAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        //Setting constraints for userImageView
        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: 40),
            userImageView.heightAnchor.constraint(equalToConstant: 40),
            userImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            userImageView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5)
            //detailView.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10)
            ])
        // layoutIfNeeded() To make snaperImageView round. Adding this to somewhere else will create constraint warnings.
        
        //Setting constraints for detailView
        NSLayoutConstraint.activate([
            detailView.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10),
            detailView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5),
            detailView.heightAnchor.constraint(equalToConstant: 40)
            //closeButton.leftAnchor.constraint(equalTo: detailView.rightAnchor, constant: 10)
            ])
//        
//        //Setting constraints for closeButton
//        NSLayoutConstraint.activate([
//            closeButton.leftAnchor.constraint(equalTo: detailView.rightAnchor, constant: 10),
//            closeButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//            closeButton.widthAnchor.constraint(equalToConstant: 60),
//            closeButton.heightAnchor.constraint(equalToConstant: 80)
//            ])
//        
        //Setting constraints for nameLabel
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: detailView.leftAnchor),
            lastUpdatedLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10.0),
            nameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            nameLabel.centerYAnchor.constraint(equalTo: detailView.centerYAnchor)
            ])
        
        //Setting constraints for lastUpdatedLabel
        NSLayoutConstraint.activate([
            lastUpdatedLabel.centerYAnchor.constraint(equalTo: detailView.centerYAnchor),
            lastUpdatedLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant:10.0)
            ])
    }
    
    private func createProgressBarView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
           let storyProgress = getStoryProgressView(with: viewModel.storyIndex) {
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
        let storyBar =  progressView.subviews.filter({
            v in v.tag == index+progressIndicatorViewTag
        }).first as? StoryBarView ?? nil
        
        return storyBar
    }
    
    func getStoryProgressView(with index: Int) -> StoryBarProgressView? {
        if progressView.subviews.count > 0 {
            let storyProgress = getStoryBarView(with: index)?.subviews.first as? StoryBarProgressView
            return storyProgress
        }
        return nil
    }
}
