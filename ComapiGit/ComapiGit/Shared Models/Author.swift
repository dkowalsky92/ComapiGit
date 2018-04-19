//
//  Author.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import Foundation

struct Author: Decodable {
    var id: Int
    var login: String
    var avatarUrl: String?
}
