//
//  Date+Extension.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: self)
    }
    
    func stringWith(format: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: self)
    }
}
