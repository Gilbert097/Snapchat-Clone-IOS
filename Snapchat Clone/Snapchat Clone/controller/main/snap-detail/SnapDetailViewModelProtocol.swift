//
//  SnapDetailViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 14/11/21.
//

import Foundation

protocol SnapDetailViewModelProtocol {
    //typealias Input = ()
    typealias Output = Dynamic<DynamicData<SnapDetailEventType>>
    
    func bind(imageData: Dynamic<Data?>) -> Output
    
    func uploadImage()
}
