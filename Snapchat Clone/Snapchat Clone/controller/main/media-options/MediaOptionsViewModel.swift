//
//  MediaOptionsViewModel.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/11/21.
//

import Foundation

class MediaOptionsViewModel: MediaOptionsViewModelProtocol{
   
    private let output = Dynamic<MediaOptionsEventType>(.none)
    
    func bind() -> Output { output }
    
    func createMedia(type: MediaType) {
        switch(type){
        case .story:
            output.value = .createStory
        case .publish:
            output.value = .createPublish
        }
    }
}
