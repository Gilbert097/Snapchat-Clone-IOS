//
//  SnapDetailViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 12/10/21.
//

import Foundation
protocol SnapListViewModelProtocol {
    
    //typealias Input = (email: Dynamic<String>, password: Dynamic<String>)
    typealias Output = Dynamic<DynamicData<SnapListEventType>>
    
    func bind() -> Output
    func signOut()
}
