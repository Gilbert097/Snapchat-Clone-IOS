//
//  StorieCollectionViewCell.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/04/21.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    
    class var reuseIdentifier: String {
        return "StoryCollectionViewCellReuseIdentifier"
    }
    
}
