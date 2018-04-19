//
//  ServerConfiguration.swift
//  BooksyBIZ
//
//  Created by Dominik Kowalski on 05/12/2017.
//  Copyright © 2017 Sensi Soft. All rights reserved.
//

import Foundation

class ServerConfiguration {

    var address: URL

    init(address: String) {
        self.address = URL(string: address)!
    }
}

