//
//  FriendsService.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Foundation
import Alamofire

class FriendService {
    
    let baseUrl = Config.storedConfig.apiUrl
    
    func getFriendsList() {
        
        let path = "/method/friends.get?"
        // параметры
        let parameters: Parameters = [
            "fields": "nickname, bdate, city, country, photo_200_orig",
            "access_token": Session.storedSession.token,
            "v": Config.storedConfig.apiVersion
        ]
        
        let url = baseUrl+path
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value as Any)
        }
    }
}
