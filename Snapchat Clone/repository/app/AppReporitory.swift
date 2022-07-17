//
//  AppReporitory.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 02/12/21.
//

import Foundation

class AppRepository{
    static var shared: AppRepository = {
          AppRepository()
      }()
    
    private init(){}
    
    private(set) var currentUser: User? = nil
    
    func setCurrentUser(currentUser: User?){
        self.currentUser = currentUser
    }
    
}
