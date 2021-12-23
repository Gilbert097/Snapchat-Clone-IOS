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
        var pvIndicatorArray: [StoryBarView] = []
        //var pvArray: [IGSnapProgressView] = []
        
        for i in 0..<storysCount{
            let pvIndicator = StoryBarView()
            pvIndicator.translatesAutoresizingMaskIntoConstraints = false
            getProgressView.addSubview(applyProperties(pvIndicator, with: i+progressIndicatorViewTag, alpha:0.2))
            pvIndicatorArray.append(pvIndicator)
            
//            let pv = IGSnapProgressView()
//            pv.translatesAutoresizingMaskIntoConstraints = false
//            pvIndicator.addSubview(applyProperties(pv))
//            pvArray.append(pv)
        }
        
        // Setting Constraints for all progressView indicators
        for index in 0..<pvIndicatorArray.count {
            let pvIndicator = pvIndicatorArray[index]
            if index == 0 {
                pvIndicator.leftConstraiant = pvIndicator.leftAnchor.constraint(equalTo: self.getProgressView.leftAnchor, constant: padding)
                NSLayoutConstraint.activate([
                    pvIndicator.leftConstraiant!,
                    pvIndicator.centerYAnchor.constraint(equalTo: self.getProgressView.centerYAnchor),
                    pvIndicator.heightAnchor.constraint(equalToConstant: height)
                    ])
                if pvIndicatorArray.count == 1 {
                    pvIndicator.rightConstraiant = self.getProgressView.rightAnchor.constraint(equalTo: pvIndicator.rightAnchor, constant: padding)
                    pvIndicator.rightConstraiant!.isActive = true
                }
            }else {
                let prePVIndicator = pvIndicatorArray[index-1]
                pvIndicator.widthConstraint = pvIndicator.widthAnchor.constraint(equalTo: prePVIndicator.widthAnchor, multiplier: 1.0)
                pvIndicator.leftConstraiant = pvIndicator.leftAnchor.constraint(equalTo: prePVIndicator.rightAnchor, constant: padding)
                NSLayoutConstraint.activate([
                    pvIndicator.leftConstraiant!,
                    pvIndicator.centerYAnchor.constraint(equalTo: prePVIndicator.centerYAnchor),
                    pvIndicator.heightAnchor.constraint(equalToConstant: height),
                    pvIndicator.widthConstraint!
                    ])
                if index == pvIndicatorArray.count-1 {
                    pvIndicator.rightConstraiant = self.view.rightAnchor.constraint(equalTo: pvIndicator.rightAnchor, constant: padding)
                    pvIndicator.rightConstraiant!.isActive = true
                }
            }
        }
        
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
    
    
   
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


final class StoryBarView: UIView {
    public var widthConstraint: NSLayoutConstraint?
    public var leftConstraiant: NSLayoutConstraint?
    public var rightConstraiant: NSLayoutConstraint?
}
