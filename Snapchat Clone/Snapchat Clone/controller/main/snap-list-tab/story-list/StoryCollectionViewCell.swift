//
//  StorieCollectionViewCell.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/04/21.
//

import UIKit
import SDWebImage

class StoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    private static let TAG = "StoryCollectionViewCell"
    
    class var reuseIdentifier: String {
        return "StoryCollectionViewCellReuseIdentifier"
    }
    
    func loadImage(url: String){
        LogUtils.printMessage(tag: StoryCollectionViewCell.TAG, message: "------> Start Download Image <------")
        imageView.sd_setImage(with: URL(string: url)) { image, error, cacheType, url in
            if let error = error {
                LogUtils.printMessage(tag: StoryCollectionViewCell.TAG, message: "Download image error -> \(error.localizedDescription)")
            } else {
                LogUtils.printMessage(tag: StoryCollectionViewCell.TAG, message: "Download image success!")
            }
            LogUtils.printMessage(tag: StoryCollectionViewCell.TAG, message: "------> Finish Download Image <------")
        }
    }
}
