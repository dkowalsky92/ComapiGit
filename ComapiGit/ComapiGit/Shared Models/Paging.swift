//
//  Paging.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 19/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

struct Paging {
    struct Values {
        var page: Int = 1
        var perPage: Int = 30
    }
    var next: Values
    var last: Values
}
