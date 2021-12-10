//
//  StorieViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/04/21.
//

import UIKit

class SnapListTabViewController: UIViewController {
    
    
    @IBOutlet weak var snapTableView: UITableView!
    @IBOutlet weak var storieCollectionView: UICollectionView!
    var viewModel: SnapListViewModelProtocol!
    private let manager = StoryCollectionManager()
    private var tableManager: SnapTableManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableManager = SnapTableManager(snapListViewModel: viewModel, onItemSelected: self.onItemSelected)
        snapTableView.delegate = tableManager
        snapTableView.dataSource = tableManager
        
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
                self.snapTableView.reloadData()
            }
        }
    }
    
    @IBAction func onSignOutButtonClick(_ sender: UIBarButtonItem) {
        viewModel.signOut()
    }
    
    private func onItemSelected(item: SnapItemViewModel){
        self.performSegue(withIdentifier: "snapListToDetail", sender: item)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "snapListToDetail",
           let snapDetailViewController = segue.destination as? SnapDetailViewController,
           let itemSelected = sender as? SnapItemViewModel
        {
            snapDetailViewController.viewModel = SnapDetailViewModel(snapItemViewModel: itemSelected)
        }
    }
    
}

public class SnapTableManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let snapListViewModel: SnapListViewModelProtocol
    private let onItemSelected: (SnapItemViewModel) -> Void
    init(
        snapListViewModel: SnapListViewModelProtocol,
        onItemSelected: @escaping (SnapItemViewModel) -> Void
    ){
        self.snapListViewModel = snapListViewModel
        self.onItemSelected = onItemSelected
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.snapListViewModel.snaps.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SnapTableViewCell", for: indexPath) as? SnapTableViewCell {
            let snapViewModel = self.snapListViewModel.snaps[indexPath.row]
            cell.nameLabel?.text = snapViewModel.userName
            cell.countLabel?.isHidden = snapViewModel.isVisible
            cell.countLabel?.text = String(snapViewModel.count)
            return cell
        }
        
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let snapViewModel = self.snapListViewModel.snaps[indexPath.row]
        self.onItemSelected(snapViewModel)
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
