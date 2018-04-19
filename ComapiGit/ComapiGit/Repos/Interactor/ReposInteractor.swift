//
//  ReposInteractor.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class ReposInteractor: BaseInteractor {
    func fetchRepos(page: Int, perPage: Int, completion: (([Repository], Paging?) -> ())?, failure: ((Error?) -> ())?) {
        let params = ["page" : "\(page)", "per_page" : "\(perPage)"]
        request(url: "orgs/comapi/repos", parameters: params, completion: { (repos: [Repository], paging) in
            completion?(repos, paging)
        }) { error in
            failure?(error)
        }
    }
}
