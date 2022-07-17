//
//  Story.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 18/12/21.
//

import Foundation


private extension String {
    static let id = "id"
    static let from = "from"
    static let nameUser = "nameUser"
    static let urlImage = "urlImage"
    static let nameImage = "nameImage"
    static let createDate = "createDate"
}

class Story {
    
    let id: String
    let from: String
    let nameUser: String
    let urlImage: String
    let nameImage: String
    let createDate: Int
    var status: SyncStatus
    
    init(
        id: String,
        from: String,
        nameUser: String,
        urlImage: String,
        nameImage: String,
        createDate: Int,
        status: SyncStatus
    ) {
        self.id = id
        self.from = from
        self.nameUser = nameUser
        self.urlImage = urlImage
        self.nameImage = nameImage
        self.createDate = createDate
        self.status = status
    }
    
    func toDictionary()-> [String: String]{
        [.from: from,
         .nameUser: nameUser,
         .urlImage: urlImage,
         .nameImage: nameImage,
         .createDate: String(createDate)]
    }
    
    func toString() -> String{
        "id: \(self.id), " +
        "from: \(self.from), " +
        "nameUser: \(self.nameUser), " +
        "urlImage: \(self.urlImage), " +
        "nameImage: \(self.nameImage)" +
        "createDate: \(self.createDate)"
    }
    
    static func create(
        id: String,
        dictionary: NSDictionary,
        status: SyncStatus
    ) -> Story {
        .init(
            id: id,
            from: dictionary[String.from] as? String ?? "",
            nameUser: dictionary[String.nameUser] as? String ?? "",
            urlImage: dictionary[String.urlImage] as? String ?? "",
            nameImage: dictionary[String.nameImage] as? String ?? "",
            createDate: dictionary[String.createDate] as? Int ?? 0,
            status: status
        )
    }
    
    func copy(
        id: String? = nil,
        from: String? = nil,
        nameUser: String? = nil,
        urlImage: String? = nil,
        nameImage: String? = nil,
        createDate: Int? = nil,
        status: SyncStatus? = nil
    )-> Story {
        .init(
            id: id ?? self.id,
            from: from ?? self.from,
            nameUser: nameUser ?? self.nameUser,
            urlImage: urlImage ?? self.urlImage,
            nameImage: nameImage ?? self.nameImage,
            createDate: createDate ?? self.createDate,
            status: status ?? self.status
        )
    }
}
