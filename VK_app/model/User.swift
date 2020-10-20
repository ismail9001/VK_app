//
//  User.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import Foundation

struct User {
    var name: String
    var photo: String //будет ссылкой на файл?
    //var groups: [Group]
    //var friends: [User] = []
    
    static var oneUser: User{
        return User(name: Lorem.fullName, photo: String(Int.random(in: 1...15)))
    }
    
    static var manyUsers: [User] {
        return (1...20).map{_ in User.oneUser}
    }
}
