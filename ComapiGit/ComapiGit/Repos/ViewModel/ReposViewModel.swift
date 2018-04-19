//
//  ReposViewModel.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class ReposViewModel: BaseViewModel {
    
    let interactor: ReposInteractor
    var repos: [Repository]
    
    var paging: Paging
    var loadingComplete = false
    
    var didLoadAllResults: (() -> ())?

    var didFetchRepos: ((_ repos: [Repository]) -> ())?
    var didFailReposLoad: ((Error?) -> ())?
    
    var isLoading: Bool = false
    
    override init() {
        interactor = ReposInteractor(timeout: 10.0)
        repos = []
        let next = Paging.Values(page: 1, perPage: 8)
        let last = Paging.Values(page: 1, perPage: 8)
        paging = Paging(next: next, last: last)
        
        super.init()
    }
    
    func reset() {
        repos = []
        let next = Paging.Values(page: 1, perPage: 8)
        let last = Paging.Values(page: 1, perPage: 8)
        paging = Paging(next: next, last: last)
        loadingComplete = false
    }
    
    func fetchRepos() {
        if loadingComplete {
            didLoadAllResults?()
            return
        }
        
        isLoading = true
        interactor.fetchRepos(page: paging.next.page, perPage: paging.next.perPage, completion: { [weak self] repos, paging in
            if paging != nil {
                if self?.paging.next.page == paging!.last.page {
                    self?.loadingComplete = true
                }
                self?.paging.next = paging!.next
                self?.paging.last = paging!.last
            } else {
                self?.loadingComplete = true
            }
            self?.repos.append(contentsOf: repos)
            self?.isLoading = false
            self?.didFetchRepos?(repos)
        }) { [weak self] error in
            self?.isLoading = false
            self?.didFailReposLoad?(error)
        }
    }
}
