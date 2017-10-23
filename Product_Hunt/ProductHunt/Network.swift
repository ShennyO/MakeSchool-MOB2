//
//  Network.swift
//  ProductHunt
//
//  Created by Sunny Ouyang on 9/27/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation


enum Route {
    case post
    case comments(id: String)
    
    func path() -> String {
        switch self {
        case .post:
            return "posts"
        case .comments:
            return "comments"
            
        }
    }
    
    
    func Headers() -> [String: String] {
        
        return ["Accept": "application/json",
                "Content-Type": "application/json",
                "Host": "api.producthunt.com",
                "Authorization": "Bearer 5591fd155cf2db08e3657d05d5775c4ccf7a9d6f71c60ddacdb9ea7d9c4b5f73"]
        
       
    }
    
    
    func Parameters() -> [String: String] {
        
        let date = Date()
        
        switch self {
        case .post:
            return ["per_page": String(describing: 20),
                    "search[featured]": String(describing: true),
                    "scope": "public",
                    "created_at": String(describing: date)]
            
        case let .comments(id):
            //print("iddd: \(id)")
            return ["search[post_id]": id]
            
        }
    }
    
}


class Network {
    
    static let instance = Network()
    
    let baseURL = "https://api.producthunt.com/v1/"
    let session = URLSession.shared
    
    func fetch(route: Route, completion: @escaping (Data) -> Void) {
        let fullPath = baseURL + route.path()
        print(fullPath)
        let pathURL = URL(string: fullPath)
       
        let fullURL = pathURL?.appendingQueryParameters(route.Parameters())
        print("URL: \(fullURL!)")
        var request = URLRequest(url: fullURL!)
        request.allHTTPHeaderFields = route.Headers()
        
        session.dataTask(with: request) { (data, resp, err) in

            if let data = data {
                completion(data)
            }
            
        }.resume()
        

        
        
    }
    
    
    
}






extension URL {
    
    

    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {


       
        
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
//
        return URL(string: URLString)!
    }
    // This is formatting the query parameters with an ascii table reference therefore we can be returned a json file
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }

}






















