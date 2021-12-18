//
//  StoryRepositoryProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 18/12/21.
//

import Foundation

protocol StoryRepositoryProtocol{
    func createStory(
        imageData: Data,
        completion: @escaping (Bool) -> Void
    )
}
