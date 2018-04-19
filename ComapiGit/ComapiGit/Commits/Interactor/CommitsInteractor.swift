//
//  CommitsInteractor.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class CommitsInteractor: BaseInteractor {
    func fetchCommits(forRepo repo: Repository, page: Int, perPage: Int, completion: (([Commit], Paging?) -> ())?, failure: ((Error?) -> ())?) {
        let params = ["page" : "\(page)", "per_page" : "\(perPage)"]
        request(url: "repos/comapi/\(repo.name)/commits", parameters: params, completion: { (repos: [Commit], paging) in
            completion?(repos, paging)
        }) { error in
            failure?(error)
        }
    }
    
    func fetchComments(forRepo repo: Repository, commit: Commit, page: Int, perPage: Int, completion: (([Comment], Paging?) -> ())?, failure: ((Error?) -> ())?) {
        let params = ["page" : "\(page)", "per_page" : "\(perPage)"]
        request(url: "repos/comapi/\(repo.name)/commits/\(commit.sha)/comments", parameters: params, completion: { (repos: [Comment], paging) in
            completion?(repos, paging)
        }) { error in
            failure?(error)
        }
    }
}
