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
    static var RequestToken = ""

    // MARK: Endpoints

    // Creation of Api Endpoints
    enum UrlEndpoints {

        case login
        case register
        case logout

        var stringValue: String {
            switch self {
            case .login: return APIEndpoints.EndpointStringURL.BaseUrl + APIEndpoints.EndpointStringURL.Login

            case .register: return APIEndpoints.EndpointStringURL.BaseUrl + APIEndpoints.EndpointStringURL.Register

            case .logout: return APIEndpoints.EndpointStringURL.BaseUrl + APIEndpoints.EndpointStringURL.Logout

            }
        }
    }

    // MARK: Actions

    // function to register user (POST)
    class func registerUser(userName: String, email: String, password: String, completionHandler: @escaping (Bool, String, Error?) -> Void) {

        // Creating URL and Request body
        let url = URL(string: UrlEndpoints.register.stringValue)
        let registerRequestBody = RegisterRequest(userName: userName, email: email, password: password)

        // Creating network call
        APIClientCalls.taskForPOSTRequest(url: url!, authToken: nil, body: registerRequestBody, responseType: RegisterResponse.self, errorResponseType: RegisterResponse.self) { (bool, response, errorResponse, error) in

            // Handling response
            DispatchQueue.main.async {
                if response == nil && errorResponse == nil {
                    completionHandler(false, "Some error occured!", error)
                } else {
                    if bool {
                        guard let response = response else {
                            return
                        }
                        completionHandler(true, response.message, nil)
                    } else {
                        guard let errorResponse = errorResponse else {
                            return
                        }
                        completionHandler(false, errorResponse.message, nil)
                    }
                }
            }
        }
    }

    // Function to login user (POST)
    class func loginUser(userName: String, password: String, completionHandler: @escaping (Bool, Error?, String?) -> Void) {

        // Creating URL and Request body
        let url = URL(string: UrlEndpoints.login.stringValue)
        let loginRequestBody = LoginRequest(userName: userName, password: password)

        // Creating network call
        APIClientCalls.taskForPOSTRequest(url: url!, authToken: nil, body: loginRequestBody, responseType: LoginResponse.self, errorResponseType: LoginErrorResponse.self) { (bool, response, errorResponse, error) in

            // Handling response
            DispatchQueue.main.async {

                if response == nil && errorResponse == nil {

                    completionHandler(false, error, "Some error occured!")
                } else {

                    if bool {

                        guard let response = response else {
                            return
                        }

                        ApiClientAuth.RequestToken = response.token
                        UserDefaults.standard.set(ApiClientAuth.RequestToken, forKey: "authToken")

                        completionHandler(true, nil, nil)
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


    // Function to logout user (POST)
    class func logoutUser(completionHandler: @escaping (Bool, Error?, String?) -> Void) {

        // Creating URL and Request body
        let url = URL(string: ApiClientAuth.UrlEndpoints.logout.stringValue)
        let body = LoginRequest(userName: "", password: "")

        // Creating network call
        APIClientCalls.taskForPOSTRequest(url: url!, authToken: ApiClientAuth.RequestToken, body: body, responseType: LogoutResponse.self, errorResponseType: LogoutResponse.self) { (bool, response, errorResponse, error) in

            // Handling response
            DispatchQueue.main.async {

                if response != nil && errorResponse != nil {

                    completionHandler(false, error, "Some error occured!")
                } else {

                    if bool {

                        guard let response = response else {
                            return
                        }

                        ApiClientAuth.RequestToken = ""
                        UserDefaults.standard.set(ApiClientAuth.RequestToken, forKey: "authToken")
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
}
