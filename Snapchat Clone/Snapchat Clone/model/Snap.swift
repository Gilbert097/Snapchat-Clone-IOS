//
//  Snap.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 02/12/21.
//

import Foundation

class Snap {
    
    let id: String
    let from: String
    let nameUser: String
    let description: String
    let urlImage: String
    let nameImage: String
    
    init(
        id: String,
        from: String,
        nameUser: String,
        description: String,
        urlImage: String,
        nameImage: String
    ) {
        self.id = id
        self.from = from
        self.nameUser = nameUser
        self.description = description
        self.urlImage = urlImage
        self.nameImage = nameImage
    }
    
    func toDictionary()-> [String: String]{
        ["from": from,
         "nameUser": nameUser,
         "description": description,
         "urlImage": urlImage,
         "nameImage": nameImage]
    }
    
    func toString() -> String{
        "id: \(self.id), \nfrom: \(self.from), \nnameUser: \(self.nameUser), \ndescription: \(self.description) " +
        "\nurlImage: \(self.urlImage), \nnameImage: \(self.nameImage)"
        
    }
}
