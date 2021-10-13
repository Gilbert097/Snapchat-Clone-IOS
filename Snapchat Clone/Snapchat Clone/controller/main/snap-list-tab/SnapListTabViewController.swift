//
//  StorieViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/04/21.
//

import UIKit

class SnapListTabViewController: UIViewController {
    
    @IBOutlet weak var storieCollectionView: UICollectionView!
    
    let manager = StoryCollectionManager()
    var viewModel: SnapListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.colors = [UIColor.red, UIColor.blue, UIColor.yellow]
        storieCollectionView.dataSource = manager
        storieCollectionView.delegate = manager
        let output = viewModel.bind()
        output.bind { data in
            if data.type == .navigationToBack{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onSignOutButtonClick(_ sender: UIBarButtonItem) {
        viewModel.signOut()
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


public class StoryCollectionManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var colors:[UIColor] = []
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? StoryCollectionViewCell {
            let index = arc4random_uniform(UInt32(colors.count))
            let color = colors[Int(index)]
            cell.viewContainer.backgroundColor = color
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}
