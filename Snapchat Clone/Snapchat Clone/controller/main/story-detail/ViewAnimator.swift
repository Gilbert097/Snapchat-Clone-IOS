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
    func start(with duration: TimeInterval, holderView: UIView, completion: @escaping CompletionAnimator)
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
        self.state = .running
        self.widthConstraint?.isActive = false
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 0)
        self.widthConstraint?.isActive = true
        self.widthConstraint?.constant = holderView.frame.width
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.superview?.layoutIfNeeded()
            }
        }) { [weak self] (finished) in
            self?.story.isCancelledAbruptly = !finished
            self?.state = .finished
            if finished == true {
                if let strongSelf = self {
                    return completion(strongSelf.story_identifier!, strongSelf.snapIndex!, strongSelf.story.isCancelledAbruptly)
                }
            } else {
                return completion(self?.story_identifier ?? "Unknown", self?.snapIndex ?? 0, self?.story.isCancelledAbruptly ?? true)
            }
        }
    }
    func resume() {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        state = .running
    }
    func pause() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        state = .paused
    }
    func stop() {
        resume()
        layer.removeAllAnimations()
        state = .finished
    }
    func reset() {
        state = .notStarted
        self.story.isCancelledAbruptly = true
        self.widthConstraint?.isActive = false
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 0)
        self.widthConstraint?.isActive = true
    }
}
