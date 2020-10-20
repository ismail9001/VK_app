//
//  Group.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import Foundation

struct Group: Equatable {
    
    var title: String
    var photo: String
    
    static var oneGroup: Group {
        return Group(title: Lorem.title, photo: "groups/\(Int.random(in: 1...15))g")
    }
    
    static var manyGroup: [Group] {
        return (1...20).map{_ in Group.oneGroup}
    }
}
