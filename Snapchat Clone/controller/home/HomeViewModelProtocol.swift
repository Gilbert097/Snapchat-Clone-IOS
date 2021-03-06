//
//  HomeViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 26/04/21.
//

import Foundation

protocol HomeViewModelProtocol {
    typealias Output = Event<EventData<HomeEventType>>
    
    func bind() -> Output
    
    func checkUserLogged()
}
