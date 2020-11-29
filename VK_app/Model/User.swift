//
//  User.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import Foundation
import SwiftyJSON

struct User{
    var id: Int
    var name: String
    var photo: String
    var photos: [Photo]
    
    init?(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.photo = json["photo_200_orig"].stringValue
        self.photos = Photo.manyPhotos
    }
    
    static var oneUser: User{
        return User(json: "")!
    }
    
    static var manyUsers: [User] {
        return (1...20).map{_ in User.oneUser}
    }
}
