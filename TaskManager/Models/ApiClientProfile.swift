//
//  ApiClientProfile.swift
//  TaskManager
//
//  Created by Ayush on 04/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation

class ApiClientProfile {

    // Creation of AuthEndpointURLStrings
    enum URLEndpoints {

        case userProfile

        var stringValue: String {

            switch self {

            case .userProfile: return APIEndpoints.EndpointStringURL.BaseUrl + APIEndpoints.EndpointStringURL.UserProfile
            }
        }
    }

    // MARK: Actions

    class func getUserProfile(completionHandler: @escaping (Bool, Error?, String?, UserObj?, TaskCount?) -> Void) {

        let url = URL(string: URLEndpoints.userProfile.stringValue)

        APIClientCalls.taskForGETRequest(url: url!, authToken: ApiClientAuth.RequestToken, responseType: UserProfileResponse.self, errorResponseType: UserProfileErrorResponse.self) { (bool, response, errorResponse, error) in

            DispatchQueue.main.async {

                if response == nil && errorResponse == nil {
                    completionHandler(false, error, "Some error occured, try again!", nil, nil)
                } else {

                    if bool {

                        guard let response = response else {
                            return
                        }
                        completionHandler(true, nil, nil, response.message, response.tasks)
                    } else {

                        guard let errorResponse = errorResponse else {
                            return
                        }
                        completionHandler(false, nil, errorResponse.message, nil, nil)
                    }
                }
            }
        }
    }
}
    

