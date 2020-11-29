//
//  Group.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import Foundation
import SwiftyJSON

struct Group: Equatable {
    
    var title: String
    var photo: String
    
    init?(json: JSON) {
        self.title = json["name"].stringValue
        self.photo = json["photo_100"].stringValue
    }
    
    static var oneGroup: Group {
        return Group(json: "")!
    }
    
    static var manyGroup: [Group] {
        return (1...20).map{_ in Group.oneGroup}
    }
}
