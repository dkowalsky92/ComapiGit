//
//  HTTPResponse.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 19/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

extension HTTPURLResponse {
    
    func parsePaging() -> Paging? {
        if let links = allHeaderFields["Link"] as? String {
            let values = links.components(separatedBy: ",")

            var next: Paging.Values?
            var last: Paging.Values?
            
            for value in values {
                if value.contains("rel=\"next\"") {
                    guard let val = extract(value: value) else { return nil }
                    next = val
                } else if value.contains("rel=\"last\"") {
                    guard let val = extract(value: value) else { return nil }
                    last = val
                }
            }
            
            if next != nil && last != nil {
                return Paging(next: next!, last: last!)
            }
        }

        return nil
    }
    
    private func extract(value: String) -> Paging.Values? {
        guard let perPageRegex = try? NSRegularExpression(pattern: "per_page=\\d+", options: [.caseInsensitive]) else { return nil }
        guard let pageRegex = try? NSRegularExpression(pattern: "&page=\\d+", options: [.caseInsensitive]) else { return nil }
        let perPageMatches = perPageRegex.matches(in: value, options: [], range: NSMakeRange(0, value.utf16.count))
        let pageMatches = pageRegex.matches(in: value, options: [], range: NSMakeRange(0, value.utf16.count))
        
        var perPage: Int = 1
        var page: Int = 1
        
        if perPageMatches.count > 0 {
            let range = perPageMatches[0].range
            let matchString = value[Range(range, in: value)!]
            perPage = Int(String(matchString.last!))!
        }
        
        if pageMatches.count > 0 {
            let range = pageMatches[0].range
            let matchString = value[Range(range, in: value)!]
            page = Int(String(matchString.last!))!
        }
        
        return Paging.Values(page: page, perPage: perPage)
    }
}
