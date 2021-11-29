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
        completion: @escaping (Bool, MediaMetadata?) -> Void
    ) {
        
        let storage = Storage.storage().reference()
        let imagePath = storage.child("imagens").child(path)
        let imageName = generateImageName()
        let imageReference = imagePath.child(imageName)
        
        imageReference.putData(imageData, metadata: nil) { metadata, error in
            
            if let metadata = metadata,
               let path = metadata.path{
                
                imageReference.downloadURL { url, urlError in
                    if let url = url {
                        let mediaMetadata = MediaMetadata(
                            url: url.absoluteString,
                            path: path,
                            name: imageName
                        )
                        
                        print("Media: \(String(describing: mediaMetadata.toString()))")
                        completion(true, mediaMetadata)
                    }else{
                        completion(false, nil)
                        print("DownloadURL Error: \(urlError.debugDescription)")
                    }
                }
                
            }else {
                completion(false, nil)
                print("Upload Image Error: \(error.debugDescription)")
            }
        }
    }
    
    private func generateImageName()-> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let imageName = "IMG_\(dateFormatterGet.string(from: Date())).jpg"
        print("Image Name: \(imageName)")
        return imageName
    }
    
}
