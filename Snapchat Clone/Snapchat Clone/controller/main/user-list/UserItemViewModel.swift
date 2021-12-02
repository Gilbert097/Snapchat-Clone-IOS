//
//  UserItemViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 01/12/21.
//

import Foundation

class UserItemViewModel{
    let id: String
    let fullName: String
    let email: String
    
    public init(user: User){
        self.id = user.id
        self.fullName = user.fullName
        self.email = user.email
    }
}
