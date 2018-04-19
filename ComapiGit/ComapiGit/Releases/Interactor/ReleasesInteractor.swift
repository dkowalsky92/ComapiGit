//
//  ReleasesInteractor.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class ReleasesInteractor: BaseInteractor {
    
    func fetchReleases(forRepo repo: Repository, page: Int, perPage: Int, completion: (([Release], Paging?) -> ())?, failure: ((Error?) -> ())?) {
        let params = ["page" : "\(page)", "per_page" : "\(perPage)"]
        request(url: "repos/comapi/\(repo.name)/releases", parameters: params, completion: { (repos: [Release], paging)  in
            completion?(repos, paging)
        }) { error in
            failure?(error)
        }
    }
    
}
