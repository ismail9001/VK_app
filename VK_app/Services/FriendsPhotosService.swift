//
//  FriendPhotosService.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Foundation
import Alamofire

class FriendsPhotosService {
    
    let baseUrl = Config.storedConfig.apiUrl

    func getFriendsPhotosList() {
        
        let path = "/method/photos.getAll?"
        // параметры
        let parameters: Parameters = [
            "extended": 0,
            "access_token": Session.storedSession.token,
            "v": Config.storedConfig.apiVersion
        ]
        
        let url = baseUrl+path
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value as Any)
        }
    }
}
