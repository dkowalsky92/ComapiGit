//
//  Release.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import Foundation

struct Release: Decodable {
    let id: Int
    let name: String
    let htmlUrl: String
    let publishedAt: String
    let tagName: String?
    let body: String?
    let author: Author
}
