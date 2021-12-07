//
//  Snap.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 02/12/21.
//

import Foundation

private extension String {
    static let id = "id"
    static let from = "from"
    static let nameUser = "nameUser"
    static let description = "description"
    static let urlImage = "urlImage"
    static let nameImage = "nameImage"
}

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
        [.from: from,
         .nameUser: nameUser,
         .description: description,
         .urlImage: urlImage,
         .nameImage: nameImage]
    }
    
    func toString() -> String{
        "id: \(self.id), " +
        "from: \(self.from), " +
        "nameUser: \(self.nameUser), " +
        "description: \(self.description), " +
        "urlImage: \(self.urlImage), " +
        "nameImage: \(self.nameImage)"
    }
    
    static func create(id: String, dictionary: NSDictionary) -> Snap {
        .init(
            id: id,
            from: dictionary[String.from] as? String ?? "",
            nameUser: dictionary[String.nameUser] as? String ?? "",
            description: dictionary[String.description] as? String ?? "",
            urlImage: dictionary[String.urlImage] as? String ?? "",
            nameImage: dictionary[String.nameImage] as? String ?? ""
        )
    }
}
