//
//  Products.swift
//  ProductHunt
//
//  Created by Sunny Ouyang on 9/27/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation

struct Product {
    var name: String?
    var tagline: String?
    var votes: Int?
    var imageURL: String?
    var id: Int?
    
    init(name: String, tagline: String, votes: Int, imageURL: String, id: Int) {
        self.name = name
        self.tagline = tagline
        self.votes = votes
        self.imageURL = imageURL
        self.id = id
    }
    
}

struct ProductList: Decodable {
    var posts: [Product]
}

extension Product: Decodable {
    
    enum containerKeys: String, CodingKey {
        case name
        case tagline
        case votes = "votes_count"
        case thumbnail
        case id
        
    }
    
    enum thumbnailKeys: String, CodingKey {
        case imageURL = "image_url"
    }
    
    init(from decoder: Decoder) throws {
        let topContainer = try decoder.container(keyedBy: containerKeys.self)
        let imageContainer = try topContainer.nestedContainer(keyedBy: thumbnailKeys.self, forKey: .thumbnail)
        let name = try topContainer.decodeIfPresent(String.self, forKey: .name)
        let tagline = try topContainer.decodeIfPresent(String.self, forKey: .tagline)
        let id = try topContainer.decodeIfPresent(Int.self, forKey: .id)
        
        var votes = try topContainer.decodeIfPresent(Int.self, forKey: .votes)
        
        if votes == nil {
            votes = 0
        }
        
        
        
        
        let imageURL = try imageContainer.decodeIfPresent(String.self, forKey: .imageURL)
        
        self.init(name: name!, tagline: tagline!, votes: votes!, imageURL: imageURL!, id: id!)
        
    }
}
