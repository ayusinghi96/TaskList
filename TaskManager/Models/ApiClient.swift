//
//  ApiClient.swift
//  TaskManager
//
//  Created by Ayush on 23/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

class ApiClientAuth {
    
    static var requestToken = ""
    
    struct EndpointStringURL{
        
        static let baseUrl = "http://192.168.1.118:8000/"
        
        static let register = "auth/user/register"
        static let login = "auth/user/login"
        static let logout = "auth/user/logout"
        
    }
    
    enum Endpoints {
        
        case login
        case register
        case logout
        
        var stringValue: String {
            switch self {
            case .login: return EndpointStringURL.baseUrl + EndpointStringURL.login
                
            case .register: return EndpointStringURL.baseUrl + EndpointStringURL.register
                
            case .logout: return EndpointStringURL.baseUrl + EndpointStringURL.logout
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func registerUser(userName: String, email: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void){
        
        var request = URLRequest(url: Endpoints.register.url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let body = RegisterRequest(userName: userName, email: email, password: password)
        //let body = RegisterRequest(userName: userName, password: password)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                completionHandler(false, error)
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(RegisterResponse.self, from: data)
                print(responseObject.success)
                
                completionHandler(true, nil)
                
            }catch{
                completionHandler(false, error)
            }
        }
        task.resume()
    }
    
    class func loginUser(userName: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.login.url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let body = LoginRequest(userName: userName, password: password)
        
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                completionHandler(false, error)
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(LoginResponse.self, from: data)
                
                ApiClientAuth.requestToken = responseObject.token
                print("AUthToken - \(ApiClientAuth.requestToken)")
                //LoginViewController.adminName = responseObject.username
                completionHandler(true, nil)
                
            }catch{
                completionHandler(false, error)
            }
        }
        task.resume()
    }
    
    
    class func logoutUser(completionHandler: @escaping (Bool, Error?) -> Void){
        
        var request = URLRequest(url: Endpoints.logout.url)
        request.addValue(ApiClientAuth.requestToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else{
                completionHandler(false, error)
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(LogoutResponse.self, from: data)
                
                if responseObject.success == "Success"{
                    ApiClientAuth.requestToken = ""
                    print("AUthToken - \(ApiClientAuth.requestToken)")
                    completionHandler(true, nil)
                }
            }catch{
                completionHandler(false, error)
            }
        }
        task.resume()
    }
    
    
    
}
