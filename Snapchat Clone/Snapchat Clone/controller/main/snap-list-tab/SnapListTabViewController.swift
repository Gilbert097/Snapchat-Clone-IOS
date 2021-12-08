//
//  StorieViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/04/21.
//

import UIKit

class SnapListTabViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var storieCollectionView: UICollectionView!
    
    let manager = StoryCollectionManager()
    var tableManager: SnapTableManager!
    var viewModel: SnapListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableManager = SnapTableManager(snapListViewModel: viewModel)
        tableView.delegate = tableManager
        tableView.dataSource = tableManager
        
        viewModel.loadSnaps()
        manager.colors = [UIColor.red, UIColor.blue, UIColor.yellow]
        storieCollectionView.dataSource = manager
        storieCollectionView.delegate = manager
        
     
        let output = viewModel.bind()
        output.bind { [weak self] data in
            guard let self = self else { return }
            switch data.type {
            case .none:
                return
            case .navigationToBack:
                self.dismiss(animated: true, completion: nil)
            case .reloadSnapList:
                self.tableView.reloadData()
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

public class SnapTableManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let snapListViewModel: SnapListViewModelProtocol
    
    init(
        snapListViewModel: SnapListViewModelProtocol
    ){
        self.snapListViewModel = snapListViewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.snapListViewModel.snaps.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SnapTableViewCell", for: indexPath) as? SnapTableViewCell {
            let snap = self.snapListViewModel.snaps[indexPath.row]
            cell.nameLabel?.text = snap.nameUser
            cell.emailLabel?.text = snap.from
            return cell
        }
        
        return UITableViewCell()
    }
    
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
