//
//  APIClientCalls.swift
//  TaskManager
//
//  Created by Ayush on 15/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

class APIClientCalls {

    // Creating ClientTask for POST METHODS
    class func taskForPOSTRequest<RequestType:Encodable, ResponseType:Decodable, ErrorResponseType:Decodable>(url: URL, authToken: String?, body: RequestType?, responseType: ResponseType.Type, errorResponseType: ErrorResponseType.Type, completionHandler: @escaping (Bool, ResponseType?, ErrorResponseType?, Error?) -> Void) {

        // Creating URL request
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        if body != nil {
            request.httpBody = try! JSONEncoder().encode(body)
        }
        if authToken != nil {
            request.addValue(authToken!, forHTTPHeaderField: "Authorization")
        }


        // Creating a URLSession task to perfrom the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            // Checking to see if data returned is null
            guard let data = data else {
                completionHandler(false, nil, nil, error)
                return
            }

            // Decoding and reading the JSONResponse from above data
            let httpResponse = response as! HTTPURLResponse

            if httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(ResponseType.self, from: data)

                    completionHandler(true, responseObject, nil, nil)
                } catch {
                    completionHandler(false, nil, nil, error)
                }
            } else {
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(ErrorResponseType.self, from: data)

                    completionHandler(false, nil, responseObject, nil)
                } catch {
                    completionHandler(false, nil, nil, error)
                }
            }

        }
        task.resume()
    }

    // Creating ClientTask for GET METHODS
    class func taskForGETRequest<ResponseType:Decodable, ErrorResponseType:Decodable>(url: URL, authToken: String, responseType: ResponseType.Type, errorResponseType: ErrorResponseType.Type, completionHandler: @escaping (Bool, ResponseType?, ErrorResponseType?, Error?) -> Void) {

        // Creating URL request
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.addValue(authToken, forHTTPHeaderField: "Authorization")

        // Creating a URLSession task to perfrom the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            // Checking to see if data returned is null
            guard let data = data else {
                completionHandler(false, nil, nil, error)
                return
            }

            // Decoding and reading the JSONResponse from above data
            let httpResponse = response as! HTTPURLResponse

            if httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(ResponseType.self, from: data)

                    completionHandler(true, responseObject, nil, nil)
                } catch {
                    completionHandler(false, nil, nil, error)
                }
            } else {
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(ErrorResponseType.self, from: data)

                    completionHandler(false, nil, responseObject, nil)
                } catch {
                    completionHandler(false, nil, nil, error)
                }
            }

        }
        task.resume()
    }
}
