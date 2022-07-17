//
//  MediaMetadata.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 28/11/21.
//

import Foundation

class MediaMetadata{
    
    let url: String
    let path: String
    let name: String
    
    init(url: String, path: String, name: String) {
        self.url = url
        self.path = path
        self.name = name
    }
    
    func toString()-> String{
        "Name: \(self.name), Path: \(self.path), Url: \(self.url)"
    }
}
