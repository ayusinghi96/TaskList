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
    
    // List of AuthEndpoints
    struct EndpointStringURL{
        
        static let addTask = "task"
        static let getTask = "task"
        static let successTask = "task/done"
        static let cancelTask = "task/cancel"
    }
    
    // Creation of AuthEndpointURL
    enum Endpoints {
        
        case addTask
        case getTask
        case successTask
        case cancelTask
        
        var stringValue: String {
            switch self {
            case .addTask: return ApiClientAuth.EndpointStringURL.baseUrl + EndpointStringURL.addTask
                
            case .getTask: return ApiClientAuth.EndpointStringURL.baseUrl + EndpointStringURL.getTask
                
            case .successTask: return ApiClientAuth.EndpointStringURL.baseUrl + EndpointStringURL.successTask
                
            case .cancelTask: return ApiClientAuth.EndpointStringURL.baseUrl + EndpointStringURL.cancelTask
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Actions
    
    class func addTask(title: String, description: String, date: String, completionHandler: @escaping(Bool, Error?, String) -> Void){
        
        // Creating a URLRequest
        var request = URLRequest(url: Endpoints.addTask.url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ApiClientAuth.requestToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body = AddTaskRequest(taskTitle: title, taskDescription: description, taskCreatedOn: date)
        request.httpBody = try! JSONEncoder().encode(body)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else{
                completionHandler(false, nil, "Could not connect to server!")
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(AddTaskResponse.self, from: data)
                
                if responseObject.status == 200 {
                    completionHandler(true, nil, responseObject.message)
                }else{
                    completionHandler(false, nil, responseObject.message)
                }
            }catch{
                completionHandler(false, error, "Some error occured, try again!")
            }
        }
        task.resume()
        
    }
    
    
    class func getTask(completionHandler: @escaping (Bool, Error?, String?, [TaskObj]?) -> Void){
        
        var tasks = [TaskObj]()
        
        var request = URLRequest(url: Endpoints.getTask.url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Authorization", forHTTPHeaderField: ApiClientAuth.requestToken)
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
                    let responseObj = try decoder.decode(GetTaskResponse.self, from: data)
                    
                    tasks = responseObj.task
                    completionHandler(true, nil, nil, tasks)
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
    
    
    class func changeTaskState(url: URL, taskID: Int, completionHandler: @escaping (Bool, Error?, String)->Void){
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Authorization", forHTTPHeaderField: ApiClientAuth.requestToken)
        request.httpMethod = "POST"
        let body = ChangeTaskStateRequest(taskId: taskID)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else{
                completionHandler(false, nil, "Could not connect to server!")
                return
            }
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
    
}
