//
//  ApiClientTask.swift
//  TaskManager
//
//  Created by Ayush on 01/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

class ApiClientTask {
    
    // MARK: Endpoints
    
    // Creation of AuthEndpointURL
    enum Endpoints {
        
        case addTask
        case getTask
        case successTask
        case getCompletedTask
        case cancelTask
        case getCancelledTask
        case getTaskHistory
        
        var stringValue: String {
            switch self {
            case .addTask: return APIEndpoints.EndpointStringURL.baseUrl + APIEndpoints.EndpointStringURL.addTask
                
            case .getTask: return APIEndpoints.EndpointStringURL.baseUrl + APIEndpoints.EndpointStringURL.getTask
                
            case .successTask: return APIEndpoints.EndpointStringURL.baseUrl + APIEndpoints.EndpointStringURL.successTask
                
            case .getCompletedTask: return APIEndpoints.EndpointStringURL.baseUrl + APIEndpoints.EndpointStringURL.successTask
                
            case .cancelTask: return APIEndpoints.EndpointStringURL.baseUrl + APIEndpoints.EndpointStringURL.cancelTask
                
            case .getCancelledTask: return APIEndpoints.EndpointStringURL.baseUrl + APIEndpoints.EndpointStringURL.cancelTask
                
            case .getTaskHistory: return APIEndpoints.EndpointStringURL.baseUrl + APIEndpoints.EndpointStringURL.getTaskHistory
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Actions
    // MARK: POST
    // Adding a new task to the database (POST)
    class func addTask(title: String, description: String, date: String, completionHandler: @escaping(Bool, Error?, String, TaskObj?) -> Void){
        
        // Creating a URLRequest
        var request = URLRequest(url: Endpoints.addTask.url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ApiClientAuth.requestToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body = AddTaskRequest(taskTitle: title, taskDescription: description, taskCreatedOn: date)
        request.httpBody = try! JSONEncoder().encode(body)
        
        // Creating a URLSession task to perfrom the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else{
                completionHandler(false, nil, "Could not connect to server!", nil)
                return
            }
            
            // Decoding and reading the JSONResponse from above data
            let response = response as! HTTPURLResponse
            if response.statusCode == 200{
                do{
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(AddTaskResponse.self, from: data)
                    
                    completionHandler(true, nil, "Task Added successfully", responseObject.task)
                    
                }catch{
                    completionHandler(false, error, "Some error occured, try again!", nil)
                }
            }else{
                do{
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(AddTaskErrorResponse.self, from: data)
                    
                    completionHandler(true, nil, responseObject.message, nil)
                    
                }catch{
                    completionHandler(false, error, "Some error occured, try again!", nil)
                }
            }
            
        }
        task.resume()
        
    }
    
    // Changing the state of the current task to "done"(POST)
    class func changeStateToDone(url: URL, taskID: String, completionHandler: @escaping (Bool, Error?, String)->Void){
        
        // Creating a URL Request
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ApiClientAuth.requestToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body = ChangeTaskStateToDone(taskId: taskID)
        request.httpBody = try! JSONEncoder().encode(body)
        
        // Creating a URLSession task to perfrom the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Checking to see if data returned is null
            guard let data = data else{
                completionHandler(false, nil, "Could not connect to server!")
                return
            }
            
            // Decoding and reading the JSONResponse from above data
            do{
                let decoder = JSONDecoder()
                let responseObj = try decoder.decode(ChangeTaskStateResponse.self, from: data)
                
                if responseObj.status == 200{
                    completionHandler(true, nil, responseObj.message)
                }else{
                    completionHandler(false, nil, responseObj.message)
                }
            }catch{
                completionHandler(false, error, "Some error occured, try again!")
            }
        }
        task.resume()
    }
    
    // Changing the state of the current task to "cancel"(POST)
    class func changeStateToCancel(url: URL, taskID: String, reason: String, completionHandler: @escaping (Bool, Error?, String)->Void){
        
        // Creating a URL Request
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ApiClientAuth.requestToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body = ChangeTaskStateToCancel(taskId: taskID, reason: reason)
        request.httpBody = try! JSONEncoder().encode(body)
        
        // Creating a URLSession task to perfrom the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Checking to see if data returned is null
            guard let data = data else{
                completionHandler(false, nil, "Could not connect to server!")
                return
            }
            
            // Decoding and reading the JSONResponse from above data
            do{
                let decoder = JSONDecoder()
                let responseObj = try decoder.decode(ChangeTaskStateResponse.self, from: data)
                
                if responseObj.status == 200{
                    completionHandler(true, nil, responseObj.message)
                }else{
                    completionHandler(false, nil, responseObj.message)
                }
            }catch{
                completionHandler(false, error, "Some error occured, try again!")
            }
        }
        task.resume()
    }
    
    
    // MARK: GET
    
    // Getting all tasks from the database in different calls(GET)
    class func getTask(url: URL, completionHandler: @escaping (Bool, Error?, String?, [TaskObj]?) -> Void){
        
        // Creating a URL Request
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ApiClientAuth.requestToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        // Creating a URLSession task to perfrom the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Checking to see if data returned is null
            guard let data = data else{
                completionHandler(false, nil, "Could not connect to server!", nil)
                return
            }
            
            // Decoding and reading the JSONResponse from above data
            let response = response as! HTTPURLResponse
            if response.statusCode == 200{
                do{
                    let decoder = JSONDecoder()
                    let responseObj = try decoder.decode(GetTaskResponse.self, from: data)
                    
                    completionHandler(true, nil, nil, responseObj.task)
                }catch{
                    completionHandler(false, error, "Some error occured, try again!", nil)
                }
            }else{
                do{
                    let decoder = JSONDecoder()
                    let responseObj = try decoder.decode(GetTaskErrorResponse.self, from: data)
                    
                    completionHandler(false, nil, responseObj.message, nil)
                }catch{
                    completionHandler(false, error, "Some error occured, try again!", nil)
                }
            }

        }
        task.resume()
    }
    
    
    
}
