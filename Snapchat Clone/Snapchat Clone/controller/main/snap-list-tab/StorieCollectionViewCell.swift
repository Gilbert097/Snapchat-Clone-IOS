//
//  StorieCollectionViewCell.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/04/21.
//

import UIKit

class StorieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    
    class var reuseIdentifier: String {
        return "StorieCollectionViewCellReuseIdentifier"
    }
    
}
