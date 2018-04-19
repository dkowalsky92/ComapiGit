//
//  Repository.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    var id: Int
    var name: String
    var htmlUrl: String
    var language: String?
}
