//
//  StoryBarProgressView.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 24/12/21.
//

import UIKit

final class StoryBarProgressView: UIView, ViewAnimator {
    
    //public var story_identifier: String?
    //public var snapIndex: Int?
    public var viewModel: StoryBarViewModel!
    public var widthConstraint: NSLayoutConstraint? = nil
    public var state: ProgressorState = .notStarted
    
}
