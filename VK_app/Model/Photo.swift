//
//  Photo.swift
//  VK_app
//
//  Created by macbook on 21.10.2020.
//

import Foundation
import SwiftyJSON

struct Photo {
    
    var liked: Bool
    var likes: Int
    var photo: String
    
    init?(json: JSON) {
        self.liked = json["likes"]["user_likes"].intValue == 0 ? false : true
        self.likes = json["likes"]["count"].intValue
        self.photo = ""
        for (index, object) in json["sizes"] {
            if object["type"] == "x"
            {self.photo = object["url"].stringValue}
        }
    }
    
    static var onePhoto: Photo{
        return Photo(json: "")!
    }
    
    static var manyPhotos: [Photo] {
        return (1...20).map{_ in Photo.onePhoto}
    }
}
