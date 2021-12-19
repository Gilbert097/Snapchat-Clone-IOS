//
//  StorieViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/04/21.
//

import UIKit

class SnapListTabViewController: UIViewController {
    private static let TAG = "SnapListTabViewController"
    
    @IBOutlet weak var snapTableView: UITableView!
    @IBOutlet weak var storieCollectionView: UICollectionView!
    var viewModel: SnapListViewModelProtocol!
    private var storyManager: StoryCollectionManager!
    private var tableManager: SnapTableManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableManager = SnapTableManager(snapListViewModel: viewModel, onItemSelected: self.onItemSelected)
        snapTableView.delegate = tableManager
        snapTableView.dataSource = tableManager
        
        
        storyManager = StoryCollectionManager(snapListViewModel: viewModel)
        storieCollectionView.dataSource = storyManager
        storieCollectionView.delegate = storyManager
        
        configureBind()
        
        viewModel.start()
    }
    
    private func configureBind() {
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
            case .reloadStoyList:
                self.storieCollectionView.reloadData()
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
            snapDetailViewController.viewModel = SnapDetailViewModel(
                snapItemViewModel: itemSelected,
                snapRepository: SnapRepository(mediaService: MediaService())
            )
        }
    }
    
}

public class SnapTableManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    private static let TAG = "SnapTableManager"
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
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            LogUtils.printMessage(tag: SnapTableManager.TAG, message: "Delete event executed.")
            let snapViewModel = self.snapListViewModel.snaps[indexPath.row]
            snapListViewModel.deleteItem(item: snapViewModel)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let snapViewModel = self.snapListViewModel.snaps[indexPath.row]
        self.onItemSelected(snapViewModel)
    }
}


public class StoryCollectionManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private static let TAG = "StoryCollectionManager"
    private let snapListViewModel: SnapListViewModelProtocol
    
    init(
        snapListViewModel: SnapListViewModelProtocol
    ){
        self.snapListViewModel = snapListViewModel
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.snapListViewModel.storys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? StoryCollectionViewCell {
            let storyItem = self.snapListViewModel.storys[indexPath.row]
            if let story = storyItem.storys.first{
                cell.loadImage(url: story.urlImage)
            }
            cell.counterLabel.text = String(storyItem.count)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}
