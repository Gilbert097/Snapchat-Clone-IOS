//
//  UsersTableViewController.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/11/21.
//

import UIKit

class UserListTableViewController: UITableViewController {
    
    var viewModel: UserListTableViewModelProtocol!
    let userSelected: Event<UserItemViewModel?> = .init(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadList()
        let output = viewModel.bind(userSelected)
        
        output.userListEvent.bind { event in
            switch(event){
            case .none:
                break
            case .reloadList:
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let user = self.viewModel.users[indexPath.row]
        cell.textLabel?.text = user.fullName
        cell.detailTextLabel?.text = user.email
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true) {
            self.userSelected.value = self.viewModel.users[indexPath.row]
        }
    }
    
    
}
