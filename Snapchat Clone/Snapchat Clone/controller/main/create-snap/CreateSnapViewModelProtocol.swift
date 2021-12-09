//
//  SnapDetailViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 14/11/21.
//

import Foundation

protocol CreateSnapViewModelProtocol {
    typealias Output = Event<EventData<CreateSnapEventType>>
    typealias Input = (
        userSelected: Event<UserItemViewModel?>,
        imageData: Event<Data?>,
        descriptionSnap:  Event<String?>
    )
    
    func bind(input: Input) -> Output
    
    func uploadImage()
}
