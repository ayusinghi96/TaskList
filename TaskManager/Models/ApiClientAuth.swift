//
//  ApiClientAuth.swift
//  TaskManager
//
//  Created by Ayush on 23/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

class ApiClientAuth {
    
    // MARK: Keys
    static var requestToken = ""
    
    // MARK: Endpoints
    
    // Creation of AuthEndpointURL
    enum Endpoints {
        
        case login
        case register
        case logout
        
        var stringValue: String {
            switch self {
            case .login: return APIEndpoints.EndpointStringURL.baseUrl + APIEndpoints.EndpointStringURL.login
                
            case .register: return APIEndpoints.EndpointStringURL.baseUrl + APIEndpoints.EndpointStringURL.register
                
            case .logout: return APIEndpoints.EndpointStringURL.baseUrl + APIEndpoints.EndpointStringURL.logout
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Actions
    
    // function to register user (POST)
    class func registerUser(userName: String, email: String, password: String, completionHandler: @escaping (Bool, Error?, String) -> Void){
        
        // Creating a URLRequest
        var request = URLRequest(url: Endpoints.register.url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let body = RegisterRequest(userName: userName, email: email, password: password)
        request.httpBody = try! JSONEncoder().encode(body)
        
        
        // Creating a URLSession task to perfrom the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Checking to see if data returned is null
            guard let data = data else{
                completionHandler(false, error, "Could not connect to server")
                return
            }
            
            // Decoding and reading the JSONResponse from above data
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(RegisterResponse.self, from: data)
                
                if responseObject.status == 200{
                    completionHandler(true, nil, responseObject.message)
                }else{
                    
                    completionHandler(false, error, responseObject.message)
                }
            }catch{
                completionHandler(false, error, "Some error occured, try again!")
            }
        }
        task.resume()
    }
    
    // Function to login user (POST)
    class func loginUser(userName: String, password: String, completionHandler: @escaping (Bool, Error?, String?) -> Void){
        
        // Creating a URLRequest
        var request = URLRequest(url: Endpoints.login.url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let body = LoginRequest(userName: userName, password: password)
        request.httpBody = try! JSONEncoder().encode(body)
        
        // Creating a URLSession task to perfrom the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Checking to see if data returned is null
            guard let data = data else{
                completionHandler(false, error, "Could not connect to server")
                return
            }
            
            // Decoding and reading the JSONResponse from above data
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 200{
                do{
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(LoginResponse.self, from: data)
                    
                    ApiClientAuth.requestToken = responseObject.token
                    UserDefaults.standard.set(ApiClientAuth.requestToken, forKey: "authToken")
                    print("auth-\(ApiClientAuth.requestToken)")
                    completionHandler(true, nil, nil)
                }catch{
                    completionHandler(false, error, "Some error occured, try again!")
                }
            }else{
                do{
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(LoginErrorResponse.self, from: data)
                    
                    completionHandler(false, nil, responseObject.message)
                }catch{
                    completionHandler(false, error, "Some error occured, try again!")
                }
            }

        }
        task.resume()
    }
    
    // Function the logout user (POST)
    class func logoutUser(completionHandler: @escaping (Bool, Error?, String?) -> Void){
        
        // Creating a URLRequest
        var request = URLRequest(url: Endpoints.logout.url)
        //request.addValue(ApiClientAuth.requestToken, forHTTPHeaderField: "auth-token")
        request.addValue(ApiClientAuth.requestToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        // Creating a URLSession task to perfrom the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Checking to see if data returned is null
            guard let data = data else{
                completionHandler(false, error, "Could not connect to server")
                return
            }
           
            // Decoding and reading the JSONResponse from above data
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(LogoutResponse.self, from: data)
                
                if responseObject.status == 200 {
                    ApiClientAuth.requestToken = ""
                    UserDefaults.standard.set(ApiClientAuth.requestToken, forKey: "authToken")
                    completionHandler(true, nil, nil)
                }else{
                    completionHandler(false, error, responseObject.message)
                }
            }catch{
                completionHandler(false, error, "Some error occured, try again!")
            }
        }
        task.resume()
    }
}
