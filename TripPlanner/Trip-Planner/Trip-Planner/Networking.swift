//
//  Networking.swift
//  Trip-Planner
//
//  Created by Sunny Ouyang on 10/15/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation

//enum HTTPMethod: String {
//    case get = "GET"
//    case post = "POST"
//}

enum Route {
    
    //our GET request route has two choices, to either get the users or the trips
    
    
    //how many routes do I need? I need one for post, one for get, one for patch, and one for delete. Do I need 8 routes?
    //To pass authentication, I'm going to need
//    case user(method: HTTPMethod)
    
    case post_user(email: String, password: String)
    case get_user
    case patch_user
    case delete_user
    case post_trip(email: String, destination: String, startDate: String, endDate: String, waypoints: Any, completed: Bool)
    case get_trip
    case patch_trip
    case delete_trip
    
    func method() -> String {
        
        switch self {
//        case let .user(method):
//            return method.rawValue
        case .post_user, .post_trip:
            return "POST"
        case .get_user, .get_trip:
            return "GET"
        case .patch_user, .patch_trip:
            return "PATCH"
        case .delete_user, .delete_trip:
            return "DELETE"
        }
    }
    
    
    func path() -> String {
        switch self {
        case .post_user, .get_user, .delete_user, .patch_user:
            return "users"
        case .post_trip, .get_trip, .delete_trip, .patch_trip:
            return "trips"
            
        }
    }
    //in this body we have to return the dictionary we want to create
    func body() -> Data? {
        switch self {
         case let .post_user(email,password):
            
           let user = User(username: email, email: email)
           
           let encoder = JSONEncoder()
           
           let result = try? encoder.encode(user)
           
            
           return result!
            
//            return [
//                "email": email,
//                "password": password
//            ]
        
        case let .post_trip(email, destination, startDate, endDate, waypoints, completed):
            
            
            let trip = UserTrip(email: email, destination: destination, startDate: startDate, endDate: endDate, waypoints: [], completed: true)
            
             let encoder = JSONEncoder()
            
             let result = try? encoder.encode(trip)
            
            return result
        
        default:
            return nil
        }
    }
    
    func headers(authorization: String) -> [String: String] {
        
        return ["Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "\(authorization)"]
        
    }
    
}



class Network {
    static let instance = Network()
    
    let baseURL = "http://127.0.0.1:8000/"
    let session = URLSession.shared
    
    func fetch(route: Route, token: String, completion: @escaping (Data) -> Void) {
        let fullPath = baseURL + route.path()
        
        let pathURL = URL(string: fullPath)
        
        //let fullURL = pathURL?.appendingQueryParameters(route.parameters())
        
        var request = URLRequest(url: pathURL!)
        request.httpMethod = route.method()
        request.allHTTPHeaderFields = route.headers(authorization: token)
        var body = route.body()
        
        
       
        request.httpBody = route.body()
        
        session.dataTask(with: request) { (data, resp, err) in
            print(String(describing: data) + String(describing: resp) + String(describing: err))
            print("Poop" + String(describing: resp))
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

