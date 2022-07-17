//
//  MediaServiceProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/11/21.
//

import Foundation

protocol MediaServiceProtocol{
    func uploadImage(
        userId: String?,
        imageData: Data,
        completion: @escaping (Bool, MediaMetadata?) -> Void 
    )
    
    func deleteImage(
        userId: String,
        name: String,
        completion: @escaping (Bool) -> Void
    )
}
