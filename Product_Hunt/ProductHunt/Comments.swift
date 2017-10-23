//
//  Comments.swift
//  ProductHunt
//
//  Created by Sunny Ouyang on 9/27/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation

struct Comment {
    var body: String?
    
    init(body: String) {
        self.body = body
    }
    
}

extension Comment: Decodable {
    
    enum commentContainerKey: String, CodingKey {
        case body
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: commentContainerKey.self)
        let comment = try container.decodeIfPresent(String.self, forKey: .body)
        
        self.init(body: comment!)
    }
}

struct commentList: Decodable {
    let comments: [Comment]
}
