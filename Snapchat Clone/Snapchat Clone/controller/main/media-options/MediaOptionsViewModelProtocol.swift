//
//  MediaOptionsViewModelProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/11/21.
//

import Foundation

protocol MediaOptionsViewModelProtocol {
    typealias Output = Dynamic<DynamicData<MediaOptionsEventType>>
    
    func bind() -> Output
    
    func createMedia(type: MediaType)
}
