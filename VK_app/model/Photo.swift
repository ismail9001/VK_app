//
//  Photo.swift
//  VK_app
//
//  Created by macbook on 21.10.2020.
//

import Foundation

struct Photo {
    var liked: Bool
    var likes: Int
    var photo: String
    
    static var onePhoto: Photo{
        return Photo(liked: Bool.random(), likes: Int.random(in: 0...9), photo: String(Int.random(in: 1...15)))
    }
    
    static var manyPhotos: [Photo] {
        return (1...20).map{_ in Photo.onePhoto}
    }
}
