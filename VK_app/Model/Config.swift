//
//  Config.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Foundation

class Config {
    
    static let storedConfig = Config()
    private init(){}
    
    let apiUrl: String = "https://api.vk.com"
    let apiVersion: String = "5.126"
}
