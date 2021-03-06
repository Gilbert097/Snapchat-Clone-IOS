//
//  MediaService.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/11/21.
//

import Foundation
import FirebaseStorage

class MediaService: MediaServiceProtocol{
    
    private static let TAG = "MediaService"
    
    func uploadImage(
        userId: String? = nil,
        imageData: Data,
        completion: @escaping (Bool, MediaMetadata?) -> Void
    ) {
        
        let imagePath = getImagePathReference(userId: userId)
        let imageName = generateImageName()
        let imageReference = imagePath.child(imageName)
        
        LogUtils.printMessage(tag: MediaService.TAG, message: "------> Start upload <------")
        imageReference.putData(imageData, metadata: nil) { metadata, error in
            if let metadata = metadata,
               let path = metadata.path{
                
                LogUtils.printMessage(tag: MediaService.TAG, message: "Upload Success!")
                LogUtils.printMessage(tag: MediaService.TAG, message: "------> Start Download URL <------")
                imageReference.downloadURL { url, urlError in
                    if let url = url {
                        
                        LogUtils.printMessage(tag: MediaService.TAG, message: "Download URL Success!")
                        let mediaMetadata = MediaMetadata(
                            url: url.absoluteString,
                            path: path,
                            name: imageName
                        )
                        
                        LogUtils.printMessage(tag: MediaService.TAG, message: "Media Metadata -> \(String(describing: mediaMetadata.toString()))")
                        completion(true, mediaMetadata)
                    } else {
                        LogUtils.printMessage(tag: MediaService.TAG, message: "Download URL Error -> \(urlError.debugDescription)")
                        completion(false, nil)
                    }
                    LogUtils.printMessage(tag: MediaService.TAG, message: "------> Finish Download URL <------")
                }

            }else {
                completion(false, nil)
                LogUtils.printMessage(tag: MediaService.TAG, message: "Upload Error -> \(error.debugDescription)")
            }
            LogUtils.printMessage(tag: MediaService.TAG, message: "------> Finish upload <------")
        }.observe(.progress) { snapshot in
            if let progress = snapshot.progress{
                LogUtils.printMessage(tag: MediaService.TAG, message: "Progress -> fractionCompleted: \(String(describing: progress.fractionCompleted))")
                LogUtils.printMessage(tag: MediaService.TAG, message: "----------> totalUnitCount: \(String(describing: progress.totalUnitCount))")
                LogUtils.printMessage(tag: MediaService.TAG, message: "----------> completedUnitCount: \(String(describing: progress.completedUnitCount))")
            }
        }
    }
    
    private func getImagePathReference(userId:String? = nil)-> StorageReference{
        let storage = Storage.storage().reference()
        if let userId = userId {
            return storage.child("imagens").child(userId)
        } else {
            return storage.child("public")
        }
    }
    
    func deleteImage(
        userId: String,
        name: String,
        completion: @escaping (Bool) -> Void
    ){
        let storage = Storage.storage().reference()
        LogUtils.printMessage(tag: MediaService.TAG, message: "------> Start delete image <------")
        storage.child("imagens")
            .child(userId)
            .child(name)
            .delete { error in
                if error == nil {
                    LogUtils.printMessage(tag: MediaService.TAG, message: "Delete image success!")
                    completion(true)
                } else if let error = error {
                    LogUtils.printMessage(tag: MediaService.TAG, message: "Delete image error -> \(error.localizedDescription)")
                    completion(false)
                }
                LogUtils.printMessage(tag: MediaService.TAG, message: "------> Finish delete image <------")
            }
    }
    
    private func generateImageName()-> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let imageName = "IMG_\(dateFormatterGet.string(from: Date())).jpg"
        LogUtils.printMessage(tag: MediaService.TAG, message: "Image Name -> \(imageName)")
        return imageName
    }
    
}
