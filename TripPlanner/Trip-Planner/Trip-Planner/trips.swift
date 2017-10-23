//
//  trips.swift
//  Trip-Planner
//
//  Created by Sunny Ouyang on 10/15/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation
import UIKit

struct UserTrip: Codable {
    var destination: String
    var startDate: String
    var endDate: String
    var waypoints: [String]
    var email:String
    var completed:Bool
    
    init(email: String, destination: String, startDate: String, endDate: String, waypoints: [String], completed: Bool) {
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.waypoints = waypoints
        self.completed = completed
        self.email = email
    }
    
    
}

extension UserTrip {
    
    enum CodingKeys: String, CodingKey {

        case email
        case destination
        case startDate = "start_date"
        case endDate = "end_date"
        case completed
        case waypoints
        
       
        
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let email = try container.decode(String.self, forKey: .email)
        let destination = try container.decode(String.self, forKey: .destination)
        let startDate = try container.decode(String.self, forKey: .startDate)
        let endDate = try container.decode(String.self, forKey: .endDate)
        let waypoints = try container.decode([String].self, forKey: .waypoints)
        let completed = try container.decode(Bool.self, forKey: .completed)
        
        self.init(email: email, destination: destination, startDate: startDate, endDate: endDate, waypoints: waypoints, completed: completed)

    }
    
}

//struct Trips: Decodable {
//    var trips: [Trip]
//}

