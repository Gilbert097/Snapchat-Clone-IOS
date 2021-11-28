//
//  MediaService.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/11/21.
//

import Foundation
import FirebaseStorage

class MediaService: MediaServiceProtocol{
    
    func uploadImage(
        path:String,
        imageData: Data,
        completion: @escaping (Bool) -> Void
    ) {
        
        let storage = Storage.storage().reference()
        let imagePath = storage.child("imagens").child(path)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let imageName = "IMG_\(dateFormatterGet.string(from: Date())).jpg"
        print("Image Name: \(imageName)")
        imagePath.child(imageName).putData(imageData, metadata: nil) { metadata, error in
            print("Path: \(String(describing: metadata?.path))")
            completion(error == nil)
        }
        
    }
    
}
