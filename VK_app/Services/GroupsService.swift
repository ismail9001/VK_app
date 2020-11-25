//
//  GroupsService.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Foundation
import Alamofire

class GroupsService {
    
    let baseUrl = Config.storedConfig.apiUrl

    func getGroupsList() {
        
        let path = "/method/groups.get?"
        // параметры
        let parameters: Parameters = [
            "extended": 1,
            "access_token": Session.storedSession.token,
            "v": Config.storedConfig.apiVersion
        ]
        
        let url = baseUrl+path
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value as Any)
        }
    }
    
    func groupsSearch(_ search: String) {
        
        let path = "/method/groups.search?"
        // параметры
        let parameters: Parameters = [
            "q": search,
            "access_token": Session.storedSession.token,
            "v": Config.storedConfig.apiVersion
        ]
        
        let url = baseUrl+path
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value as Any)
        }
    }
}
