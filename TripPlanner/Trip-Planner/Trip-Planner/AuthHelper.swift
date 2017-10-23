//
//  AuthHelper.swift
//  Trip-Planner
//
//  Created by Sunny Ouyang on 10/14/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation


//This is to help us turn our username and password into a token that we add into our request's authorization header 
struct BasicAuth {
    static func generateBasicAuthHeader(username: String, password: String) -> String {
        let loginString = String(format: "%@:%@", username, password)
        let loginData: Data = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString(options: .init(rawValue: 0))
        let authHeaderString = "Basic \(base64LoginString)"
        
        return authHeaderString
    }
}
