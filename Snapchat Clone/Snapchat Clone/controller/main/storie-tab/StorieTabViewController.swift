//
//  StorieViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/04/21.
//

import UIKit

class StorieTabViewController: UIViewController {
    
    @IBOutlet weak var storieCollectionView: UICollectionView!
    let manager = StorieCollectionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.colors = [UIColor.red, UIColor.blue, UIColor.yellow]
        storieCollectionView.dataSource = manager
        storieCollectionView.delegate = manager
        // Do any additional setup after loading the view.
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


 public class StorieCollectionManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var colors:[UIColor] = []
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StorieCollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? StorieCollectionViewCell {
            let index = arc4random_uniform(UInt32(colors.count))
            let color = colors[Int(index)]
            cell.viewContainer.backgroundColor = color
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}
