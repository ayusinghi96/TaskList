//
//  ApiClientTask.swift
//  TaskManager
//
//  Created by Ayush on 01/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

class ApiClientTask {

    static let Cache = NSCache<NSString, AnyObject>()

    // MARK: Endpoints

    // Creation of AuthEndpointURL
    enum UrlEndpoints {

        case addTask
        case getTask
        case successTask
        case getCompletedTask
        case cancelTask
        case getCancelledTask
        case getTaskHistory

        var stringValue: String {
            switch self {
            case .addTask: return APIEndpoints.EndpointStringURL.BaseUrl + APIEndpoints.EndpointStringURL.AddTask

            case .getTask: return APIEndpoints.EndpointStringURL.BaseUrl + APIEndpoints.EndpointStringURL.GetTask

            case .successTask: return APIEndpoints.EndpointStringURL.BaseUrl + APIEndpoints.EndpointStringURL.SuccessTask

            case .getCompletedTask: return APIEndpoints.EndpointStringURL.BaseUrl + APIEndpoints.EndpointStringURL.GetSuccessTask

            case .cancelTask: return APIEndpoints.EndpointStringURL.BaseUrl + APIEndpoints.EndpointStringURL.CancelTask

            case .getCancelledTask: return APIEndpoints.EndpointStringURL.BaseUrl + APIEndpoints.EndpointStringURL.GetCancelledTask

            case .getTaskHistory: return APIEndpoints.EndpointStringURL.BaseUrl + APIEndpoints.EndpointStringURL.GetTaskHistory
            }
        }
    }

    // MARK: Actions

    // MARK: POST
    // Adding a new task to the database (POST)
    class func addTask(title: String, description: String, date: String, completionHandler: @escaping(Bool, Error?, String, TaskObj?) -> Void) {

        // Creating URL and Request body
        let url = URL(string: UrlEndpoints.addTask.stringValue)
        let body = AddTaskRequest(taskTitle: title, taskDescription: description, taskCreatedOn: date)

        // Creating network call
        APIClientCalls.taskForPOSTRequest(url: url!, authToken: ApiClientAuth.RequestToken, body: body, responseType: AddTaskResponse.self, errorResponseType: AddTaskErrorResponse.self) { (bool, response, errorResponse, error) in

            // Handling response
            DispatchQueue.main.async {

                if response == nil && errorResponse == nil {
                    completionHandler(false, error, "Some error occured, try again!", nil)
                } else {
                    if bool {
                        guard let response = response else {
                            return
                        }
                        completionHandler(true, nil, "Task Added successfully", response.task)
                    } else {
                        guard let errorResponse = errorResponse else {
                            return
                        }
                        completionHandler(true, nil, errorResponse.message, nil)
                    }
                }
            }
        }
    }

    // Changing the state of the current task
    class func changeTaskState<RequestType:Encodable>(url: URL, body: RequestType, completionHandler: @escaping (Bool, Error?, String) -> Void) {

        // Creating network Call
        APIClientCalls.taskForPOSTRequest(url: url, authToken: ApiClientAuth.RequestToken, body: body, responseType: ChangeTaskStateResponse.self, errorResponseType: ChangeTaskStateResponse.self) { (bool, response, errorResponse, error) in

            // Handling response
            DispatchQueue.main.async {

                if response == nil && errorResponse == nil {
                    completionHandler(false, error, "Some error occured, try again!")
                } else {
                    if bool {
                        guard let response = response else {
                            return
                        }

                        completionHandler(true, nil, response.message)
                    } else {
                        guard let errorResponse = errorResponse else {
                            return
                        }
                        completionHandler(false, nil, errorResponse.message)
                    }
                }
            }
        }
    }


    // MARK: GET

    // Getting all tasks from the database in different calls(GET)
    class func downloadTask(url: URL, completionHandler: @escaping (Bool, Error?, String?, [TaskObj]?) -> Void) {

        // Creating network call
        APIClientCalls.taskForGETRequest(url: url, authToken: ApiClientAuth.RequestToken, responseType: GetTaskResponse.self, errorResponseType: GetTaskErrorResponse.self) { (bool, response, errorResponse, error) in

            // Handling response
            DispatchQueue.main.async {
                if response == nil && errorResponse == nil {
                    completionHandler(false, error, "Some error occured, try again!", nil)
                } else {
                    if bool {
                        guard let response = response else {
                            return
                        }

                        completionHandler(true, nil, nil, response.task)
                    } else {
                        guard let errorResponse = errorResponse else {
                            return
                        }
                        completionHandler(false, nil, errorResponse.message, nil)
                    }
                }
            }
        }
    }

}

//    class func getTask(url: URL, completionHandler: @escaping (Bool, Error?, String?, [TaskObj]?) -> Void){
//        guard let data = cache.object(forKey: url.absoluteString as NSString) else {
//            downloadTask(url:url, completionHandler:)
//            return
//        }
//
//    }
//
//    class func nsdataToJSON(data: NSData) -> Any? {
//        return try! JSONSerialization.jsonObject(with: data as Data, options: .mutableLeaves) as Any
//    }
//
//    class func jsonToNSData(json: Any) -> NSData?{
//        return try! JSONSerialization.data(withJSONObject: json) as NSData
//    }
//}


