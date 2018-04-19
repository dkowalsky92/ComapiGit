//
//  Comment.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 19/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import Foundation

struct Comment: Decodable {
    var id: Int
    var body: String
    var author: Author
    var createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case body
        case createdAt
        case author = "user"
    }
}
