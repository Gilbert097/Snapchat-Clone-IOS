//
//  MediaService.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/11/21.
//

import Foundation
import FirebaseStorage

class MediaService: MediaServiceProtocol{
    
    let TAG = "MediaService"
    
    func uploadImage(
        path:String,
        imageData: Data,
        completion: @escaping (Bool, MediaMetadata?) -> Void
    ) {
        
        let storage = Storage.storage().reference()
        let imagePath = storage.child("imagens").child(path)
        let imageName = generateImageName()
        let imageReference = imagePath.child(imageName)
        
        printMessage(message: "------> Start upload <------")
        imageReference.putData(imageData, metadata: nil) { [weak self] metadata, error in
            
            guard let self = self else {
                self?.printMessage(message: "Upload Error -> Context is nil.")
                return
            }
            
            self.printMessage(message: "------> Finish upload <------")
            if let metadata = metadata,
               let path = metadata.path{
                
                self.printMessage(message: "Upload Success!")
                self.printMessage(message: "------> Start Download URL <------")
                imageReference.downloadURL { url, urlError in
                    
                    self.printMessage(message: "------> Finish Download URL <------")
                    if let url = url {
                        
                        self.printMessage(message: "Download URL Success!")
                        let mediaMetadata = MediaMetadata(
                            url: url.absoluteString,
                            path: path,
                            name: imageName
                        )
                        
                        self.printMessage(message: "Media Metadata -> \(String(describing: mediaMetadata.toString()))")
                        completion(true, mediaMetadata)
                    }else{
                        completion(false, nil)
                        self.printMessage(message: "Download URL Error -> \(urlError.debugDescription)")
                    }
                }

            }else {
                completion(false, nil)
                self.printMessage(message: "Upload Error -> \(error.debugDescription)")
            }
        }.observe(.progress) { snapshot in
            if let progress = snapshot.progress{
                self.printMessage(message: "Progress -> fractionCompleted: \(String(describing: progress.fractionCompleted))")
                self.printMessage(message: "----------> totalUnitCount: \(String(describing: progress.totalUnitCount))")
                self.printMessage(message: "----------> completedUnitCount: \(String(describing: progress.completedUnitCount))")
            }
        }
    }
    
    private func generateImageName()-> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let imageName = "IMG_\(dateFormatterGet.string(from: Date())).jpg"
        printMessage(message: "Image Name -> \(imageName)")
        return imageName
    }
    
    private func printMessage(message:String){
        print("\(TAG): \(message)")
    }
}
