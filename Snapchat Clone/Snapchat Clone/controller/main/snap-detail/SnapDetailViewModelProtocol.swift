//
//  SnapDetailViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 14/11/21.
//

import Foundation

protocol SnapDetailViewModelProtocol {
    typealias Output = Dynamic<DynamicData<SnapDetailEventType>>
    typealias Input = (
        userSelected: Dynamic<User?>,
        imageData: Dynamic<Data?>,
        descriptionSnap:  Dynamic<String?>
    )
    
    func bind(input: Input) -> Output
    
    func uploadImage()
}
