//
//  Commit.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import Foundation

struct Commit: Decodable {
    let sha: String
    var comments: [Comment] = []
    let commitData: CommitData
    var committer: GitHubCommitter?
    
    var showComments: Bool = false
    var loadingComplete: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case sha
        case commitData = "commit"
        case committer
    }
}

struct CommitData: Decodable {
    let committer: Committer
}

struct Committer: Decodable {
    let name: String
    let date: String
}
