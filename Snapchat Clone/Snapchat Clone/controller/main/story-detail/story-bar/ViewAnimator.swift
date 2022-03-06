//
//  ViewAnimator.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 23/12/21.
//

import Foundation
import UIKit

typealias CompletionAnimator =  (_ storyIdentifier: String, _ snapIndex: Int, _ isCancelledAbruptly: Bool) -> Void

protocol ViewAnimator {
    
    func start(
        with duration: TimeInterval,
        holderView: UIView,
        completion: @escaping CompletionAnimator
    )
    
    func resume()
    func pause()
    func stop()
    func reset()
}

extension ViewAnimator where Self: StoryBarProgressView {
    
    func start(
        with duration: TimeInterval,
        holderView: UIView,
        completion: @escaping CompletionAnimator
    ) {
        // Modifying the existing widthConstraint and setting the width equalTo holderView's widthAchor
        self.holderViewWidth = holderView.safeAreaLayoutGuide.layoutFrame.width
        self.widthConstraint?.isActive = false
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 0)
        self.widthConstraint?.isActive = true
        
        if self.viewModel.state == .finished {
            self.widthConstraint?.constant = 0
            self.superview?.layoutIfNeeded()
        }
        
        self.widthConstraint?.constant = self.holderViewWidth
        self.viewModel.state = .running
        
         UIView.animate(withDuration: duration, delay:  0.0, options: [.curveLinear], animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.superview?.layoutIfNeeded()
            }
        }) { [weak self] (finished) in
            guard let self = self else { return }
            self.viewModel.isCancelledAbruptly = !finished
            self.viewModel.state = .finished
            completion(self.viewModel.story.id, self.viewModel.index, self.viewModel.isCancelledAbruptly)
        }
    }
    
//    func teste(
//        with duration: TimeInterval,
//        holderView: UIView,
//        completion: @escaping CompletionAnimator
//    ) {
//        // Modifying the existing widthConstraint and setting the width equalTo holderView's widthAchor
//        self.holderViewWidth = holderView.safeAreaLayoutGuide.layoutFrame.width
//        self.viewModel.state = .running
//        self.widthConstraint?.isActive = false
//        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 0)
//        self.widthConstraint?.isActive = true
//
//        self.widthConstraint?.constant = self.holderViewWidth
//
//         UIView.animate(withDuration: duration, delay:  0.0, options: [.curveLinear], animations: {[weak self] in
//            if let strongSelf = self {
//                strongSelf.superview?.layoutIfNeeded()
//            }
//        }) { [weak self] (finished) in
//            guard let self = self else { return }
//            self.viewModel.isCancelledAbruptly = !finished
//            self.viewModel.state = .finished
//            completion(self.viewModel.story.id, self.viewModel.index, self.viewModel.isCancelledAbruptly)
//        }
//    }
    
    func resume() {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        self.viewModel.state = .running
    }
    
    func pause() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        self.viewModel.state = .paused
    }
    
    func stop() {
        resume()
        layer.removeAllAnimations()
        self.viewModel.state = .finished
    }
    
    func reset() {
        self.layer.removeAllAnimations()
        self.viewModel.state = .notStarted
        self.viewModel.isCancelledAbruptly = true
        self.widthConstraint?.isActive = false
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 0)
        self.widthConstraint?.isActive = true
        self.widthConstraint?.constant = 0
    }
    
    func finish(){
        self.layer.removeAllAnimations()
        self.viewModel.state = .finished
        self.viewModel.isCancelledAbruptly = true
        self.widthConstraint?.isActive = false
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: self.holderViewWidth)
        self.widthConstraint?.isActive = true
    }
}
