//
//  ApiClientProfile.swift
//  TaskManager
//
//  Created by Ayush on 04/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

class ApiClientProfile {
    
    // MARK: Endpoints
    
    // Creation of AuthEndpointURL
    enum Endpoints {
        
        case userProfile
        
        var stringValue: String {
            switch self {
                case .userProfile: return APIEndpoints.EndpointStringURL.baseUrl + APIEndpoints.EndpointStringURL.userProfile
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Actions
    
    class func getUserProfile(completionHandler: @escaping (Bool, Error?, String?, UserObj?) -> Void){
        
        
        var request = URLRequest(url: Endpoints.userProfile.url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ApiClientAuth.requestToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else{
                completionHandler(false, nil, "Could not connect to server!", nil)
                return
            }
            
            let response = response as! HTTPURLResponse
            if response.statusCode == 200{
                do{
                    let decoder = JSONDecoder()
                    let responseObj = try decoder.decode(UserProfileResponse.self, from: data)
                    
                    let user = responseObj.message
                    completionHandler(true, nil, nil, user)
                }catch{
                    completionHandler(false, error, "Some error occured, try again!", nil)
                }
            }else{
                do{
                    let decoder = JSONDecoder()
                    let responseObj = try decoder.decode(UserProfileErrorResponse.self, from: data)
                    
                    completionHandler(false, nil, responseObj.message, nil)
                }catch{
                    completionHandler(false, error, "Some error occured, try again!", nil)
                }
            }
        }
        task.resume()
    }
}
    

