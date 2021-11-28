//
//  MediaServiceProtocol.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/11/21.
//

import Foundation

protocol MediaServiceProtocol{
    func uploadImage(
        path:String,
        imageData: Data,
        completion: @escaping (Bool, MediaMetadata?) -> Void 
    )
}
